require 'csv'
class ReportsController < ApplicationController

  def index
    @funding_sources = [FundingSource.new(:name=>"<All>")] + FundingSource.all 
    @routes = Route.all
  end

  def basic_report
    @start_date = Date.parse(params[:start_date])
    @end_date = Date.parse(params[:end_date])
    @exited_count = 0
    @work_related_vmr = 0
    @work_related_tpw = 0
    @non_work_related_vmr = 0
    @non_work_related_tpw = 0

    kases = Kase.successful.closed_in_range(@start_date..@end_date).for_funding_source_id(params[:funding_source_id]).includes(:outcomes => :trip_reason)

    for kase in kases
      @exited_count += 1

      for outcome in kase.outcomes
        vmr = outcome.exit_vehicle_miles_reduced
        tpw = outcome.exit_trip_count
        if outcome.three_month_vehicle_miles_reduced
          vmr = outcome.three_month_vehicle_miles_reduced
          tpw = outcome.three_month_trip_count
        end
        if outcome.six_month_vehicle_miles_reduced
          vmr = outcome.six_month_vehicle_miles_reduced
          tpw = outcome.six_month_trip_count
        end

        if outcome.trip_reason.work_related
          @work_related_vmr += vmr
          @work_related_tpw += tpw
        else
          @non_work_related_vmr += vmr
          @non_work_related_tpw += tpw
        end
      end
    end
  end

  def age_and_ethnicity
    @start_date = Date.parse(params[:start_date])
    @end_date = @start_date + 1.month - 1.day
    fy_start_date = Date.new(@start_date.year - (@start_date.month < 7 ? 1 : 0), 7, 1)

    @this_month_unknown_age = {}
    @this_month_sixty_plus = {}
    @this_month_less_than_sixty = {}
    @this_year_unknown_age = {}
    @this_year_sixty_plus = {}
    @this_year_less_than_sixty = {}
    @counts_by_ethnicity = {}

    Kase::VALID_COUNTIES.each do |county, county_code|
      month_customers = Customer.with_new_successful_exit_in_range_for_county(@start_date,@end_date,county_code).includes(:ethnicity).uniq
      year_customers = Customer.with_successful_exit_in_range_for_county(fy_start_date,@end_date,county_code).includes(:ethnicity).uniq

      @this_month_unknown_age[county] = 0
      @this_month_sixty_plus[county] = 0
      @this_month_less_than_sixty[county] = 0
      @this_year_unknown_age[county] = 0
      @this_year_sixty_plus[county] = 0
      @this_year_less_than_sixty[county] = 0
      @counts_by_ethnicity[county] = {}

      #first, handle the customers from this month
      for customer in month_customers
        age = customer.age_in_years
        if age.nil?
          @this_month_unknown_age[county] += 1
        elsif age > 60
          @this_month_sixty_plus[county] += 1
        else
          @this_month_less_than_sixty[county] += 1
        end

        if ! @counts_by_ethnicity[county].member? customer.ethnicity
          @counts_by_ethnicity[county][customer.ethnicity] = {'month' => 0, 'year' => 0}
        end
        @counts_by_ethnicity[county][customer.ethnicity]['month'] += 1
      end

      #now all customers for the year
      for customer in year_customers
        age = customer.age_in_years
        if age.nil?
          @this_year_unknown_age[county] += 1
        elsif age > 60
          @this_year_sixty_plus[county] += 1
        else
          @this_year_less_than_sixty[county] += 1
        end

        if ! @counts_by_ethnicity[county].member? customer.ethnicity
          @counts_by_ethnicity[county][customer.ethnicity] = {'month' => 0, 'year' => 0}
        end
        @counts_by_ethnicity[county][customer.ethnicity]['year'] += 1
      end
    end
  end

  def trainer
    #Trainer Report: Listing of training activities (Initial
    #interviews, scouts, trainings, shadows), with dates, durations.
    #Grouped by trainer with grand and by-trainer totals.

    @start_date = Date.parse(params[:start_date])
    @end_date = Date.parse(params[:end_date])

    events = Event.accessible_by(current_ability).in_range(@start_date, @end_date).includes(:event_type,:user,{:kase => [:customer,:disposition]})
    events_by_trainer = {}
    hours_by_trainer = {'{total}' => 0}
    customers_by_trainer = {'{total}' => Set.new}
    for event in events
      user = event.user
      if ! events_by_trainer.member? user
        events_by_trainer[user] = []
      end
      events_by_trainer[user].push(event)
      if ! hours_by_trainer.member? user
        hours_by_trainer[user] = 0
      end
      hours_by_trainer[user] += event.duration_in_hours
      hours_by_trainer['{total}'] += event.duration_in_hours
      if ! customers_by_trainer.member? user
        customers_by_trainer[user] = Set.new
      end
      customers_by_trainer[user].add event.kase.customer
      customers_by_trainer['{total}'].add event.kase.customer
    end

    @trainers = events_by_trainer.keys.sort_by{|x| x.email}
    @events_by_trainer = events_by_trainer
    @hours_by_trainer = hours_by_trainer
    @customers_by_trainer = customers_by_trainer
    @events = events
  end

  def trainee

    @start_date = Date.parse(params[:start_date])
    @end_date = Date.parse(params[:end_date])

    events = Event.accessible_by(current_ability).in_range(@start_date, @end_date).includes(:event_type,:user,{:kase => [:customer,:disposition]})
    kases = Kase.open_in_range(@start_date..@end_date).includes(:disposition)
    events_by_customer = {}
    hours_by_customer = {}
    dispositions = {}
    events_by_type = {}
    for event in events
      customer = event.kase.customer

      if ! events_by_customer.member? customer
        events_by_customer[customer] = []
      end
      events_by_customer[customer].push(event)

      if ! hours_by_customer.member? customer
        hours_by_customer[customer] = 0
      end
      hours_by_customer[customer] += event.duration_in_hours

      if !events_by_type.member? event.event_type
        events_by_type[event.event_type] = 0
      end
      events_by_type[event.event_type] += 1
    end
  
    dispositions = kases.group_by(&:disposition)

    @customers = events_by_customer.keys.sort_by{|x| x.name_reversed}
    @events_by_customer = events_by_customer
    @hours_by_customer = hours_by_customer
    @dispositions = dispositions
    @events_by_type = events_by_type
    @events = events.all
  end

  def route

    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    @route = Route.find(params[:route_id])
    authorize! :read, @route
    @customers = Customer.accessible_by(current_ability).find(:all, :conditions=>["kase_routes.route_id = ? and (kases.open_date between ? and ? or kases.close_date between ? and ? or (kases.close_date is null and kases.open_date < ?))", params[:route_id], start_date, end_date, start_date, end_date, end_date], :joins=>{:kases => :kase_routes}, :include=>{:kases=>:outcomes})
  end

  def outcomes
    #csv, one record per outcome
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    kases = Kase.successful.closed_in_range(start_date..end_date).includes({:outcomes=>:trip_reason},{:customer=>:ethnicity},:disposition,:assigned_to,:referral_type)
    
    csv = ""
    CSV.generate(csv) do |csv|
      csv << %w(Name DOB Ethnicity Gender Open\ Date Assigned\ To Referral\ Source Referral\ Type Close\ Date Trip\ Reason Exit\ Trip\ Count Exit\ VMR 3\ Month\ Unreachable 3\ Month\ Trip\ Count 3\ Month\ VMR 6\ Month\ Unreachable 6\ Month\ Trip\ Count 6\ Month\ VMR)
      for kase in kases
        customer = kase.customer
        if kase.outcomes.present?
          kase.outcomes.each{|outcome| csv << outcomes_row(customer, kase, outcome)}
        else
          csv << outcomes_row(customer, kase, nil)
        end
      end 
    end
    
    send_data csv, :type => "text/csv", :filename => "outcomes #{start_date.to_s} to #{end_date.to_s}.csv", :disposition => 'attachment'    
  end

  #because this is user-visible in the url, it does not match the
  #system-wide "kase" naming convention
  def cases
    #csv, one record per case with events in the period
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    kases = Kase.accessible_by(current_ability).includes({:customer => :ethnicity},:assigned_to,:disposition,:referral_type).where(:open_date => start_date..end_date)

    csv = ""
    CSV.generate(csv) do |csv|
      csv << %w(Name Open\ Date Referral\ Source Referral\ Type DOB Ethnicity Gender Phone\ Number\ 1 Phone\ Number\ 2 Email Address City State Zip Notes Assigned\ To Close\ Date Disposition)
      for kase in kases
        customer = kase.customer
        csv << [customer.name,
                kase.open_date,
                kase.referral_source,
                kase.referral_type.name,
                customer.birth_date.to_s,
                customer.ethnicity.name,
                customer.gender,
                customer.phone_number_1,
                customer.phone_number_2,
                customer.email,
                customer.address,
                customer.city,
                customer.state,
                customer.zip,
                customer.notes,
                kase.assigned_to.try(:email),
                kase.close_date,
                kase.disposition.name]
      end
    end 
    
    send_data csv, :type => "text/csv", :filename => "cases #{start_date.to_s} to #{end_date.to_s}.csv", :disposition => 'attachment'    
  end

  def events
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    events = Event.accessible_by(current_ability).includes({:kase=>[:disposition,{:customer=>:ethnicity}]},:user,:funding_source,:event_type).where(:date => start_date..end_date)

    csv = ""
    CSV.generate(csv) do |csv|
      csv << %w(Name DOB Ethnicity Gender Phone\ Number\ 1 Phone\ Number\ 2 Email Address City State Zip Notes Open\ Date Close\ Date Disposition Event\ Type Event\ Date Author Funding\ Source Hours)
      for event in events
        kase = event.kase
        customer = kase.customer
        csv << [customer.name,
                customer.birth_date.to_s,
                customer.ethnicity.name,
                customer.gender,
                customer.phone_number_1,
                customer.phone_number_2,
                customer.email,
                customer.address,
                customer.city,
                customer.state,
                customer.zip,
                customer.notes,
                kase.open_date,
                kase.close_date,
                kase.disposition.name,
                event.event_type.name,
                event.date,
                event.user.email,
                event.funding_source.name,
                event.duration_in_hours]
      end
    end
    send_data csv, :type => "text/csv", :filename => "events #{start_date.to_s} to #{end_date.to_s}.csv", :disposition => 'attachment'    
  end

  private

  def outcomes_row(customer,kase,outcome)
    [customer.name,
    customer.birth_date.to_s,
    customer.ethnicity.name,
    customer.gender,
    kase.open_date,
    kase.assigned_to.try(:email),
    kase.referral_source,
    kase.referral_type.name,
    kase.close_date,
    outcome.try(:trip_reason).try(:name),
    outcome.try(:exit_trip_count),
    outcome.try(:exit_vehicle_miles_reduced),
    outcome.try(:three_month_unreachable),
    outcome.try(:three_month_trip_count),
    outcome.try(:three_month_vehicle_miles_reduced),
    outcome.try(:six_month_unreachable),
    outcome.try(:six_month_trip_count),
    outcome.try(:six_month_vehicle_miles_reduced)]
  end

end
