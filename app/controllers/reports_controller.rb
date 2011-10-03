require 'csv'
class ReportsController < ApplicationController

  def index
    @funding_sources = [FundingSource.new(:id=>0, :name=>"all")] + FundingSource.accessible_by(current_ability) 
    @routes = Route.accessible_by(current_ability)
  end

  def basic_monthly_report
    kases = get_kases_for_month
    compute_basic_results(kases)
    render "basic_report"
  end

  def basic_annual_report
    kases = get_kases_for_year
    compute_basic_results(kases)
    render "basic_report"
  end

  def age_and_ethnicity
    month_kases = get_kases_for_month
    params[:year] = Date.parse(params[:start_date]).year
    year_kases = get_kases_for_year
    @this_month_unknown_age = 0
    @this_month_sixty_plus = 0
    @this_month_less_than_sixty = 0

    @this_year_unknown_age = 0
    @this_year_sixty_plus = 0
    @this_year_less_than_sixty = 0

    @counts_by_ethnicity = {}

    #first, handle the customers from this month
    for kase in month_kases
      customer = kase.customer

      age = customer.age_in_years
      if age.nil?
        @this_month_unknown_age += 1
      elsif age > 60
        @this_month_sixty_plus += 1
      else
        @this_month_less_than_sixty += 1
      end

      if ! @counts_by_ethnicity.member? customer.ethnicity
        @counts_by_ethnicity[customer.ethnicity] = {'month' => 0, 'year' => 0}
      end
      @counts_by_ethnicity[customer.ethnicity]['month'] += 1
    end

    #now all customers for the year
    for kase in year_kases
      age = customer.age_in_years
      if age.nil?
        @this_year_unknown_age += 1
      elsif age > 60
        @this_year_sixty_plus += 1
      else
        @this_year_less_than_sixty += 1
      end

      if ! @counts_by_ethnicity.member? customer.ethnicity
        @counts_by_ethnicity[customer.ethnicity] = {'month' => 0, 'year' => 0}
      end
      @counts_by_ethnicity[customer.ethnicity]['year'] += 1
    end

  end

  def trainer
    #Trainer Report: Listing of training activities (Initial
    #interviews, scouts, trainings, shadows), with dates, durations.
    #Grouped by trainer with grand and by-trainer totals.

    @start_date = Date.parse(params[:start_date])
    @end_date = Date.parse(params[:end_date])

    events = Event.accessible_by(current_ability).where(["date between ? and ?", @start_date, @end_date]).order('date')
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

    events = Event.accessible_by(current_ability).where(["date between ? and ?", @start_date, @end_date]).order('date')
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

      if !dispositions.member? event.kase.disposition
        dispositions[event.kase.disposition] = Set.new
      end
      dispositions[event.kase.disposition].add event.kase

      if !events_by_type.member? event.event_type
        events_by_type[event.event_type] = 0
      end
      events_by_type[event.event_type] += 1
    end

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

    kases = Kase.accessible_by(current_ability).where(:close_date => start_date..end_date)
    
    csv = ""
    CSV.generate(csv) do |csv|
      csv << %w(Name DOB Ethnicity Gender Open\ Date Assigned\ To Referral\ Source Referral\ Type Close\ Date Disposition Trip\ Reason Exit\ Trip\ Count Exit\ VMR 3\ Month\ Unreachable 3\ Month\ Trip\ Count 3\ Month\ VMR 6\ Month\ Unreachable 6\ Month\ Trip\ Count 6\ Month\ VMR)
      for kase in kases
        customer = kase.customer
        for outcome in kase.outcomes
          csv << [customer.name,
                  customer.birth_date.to_s,
                  customer.ethnicity.name,
                  customer.gender,
                  kase.open_date,
                  kase.assigned_to.email,
                  kase.referral_source,
                  kase.referral_type.name,
                  kase.close_date,
                  kase.disposition.name,
                  outcome.trip_reason.name,
                  outcome.exit_trip_count,
                  outcome.exit_vehicle_miles_reduced,
                  outcome.three_month_unreachable,
                  outcome.three_month_trip_count,
                  outcome.three_month_vehicle_miles_reduced,
                  outcome.six_month_unreachable,
                  outcome.six_month_trip_count,
                  outcome.six_month_vehicle_miles_reduced]
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

    kases = Kase.accessible_by(current_ability).includes(:customer).where(:open_date => start_date..end_date)

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
                kase.assigned_to.email,
                kase.close_date,
                kase.disposition.name]
      end
    end 
    
    send_data csv, :type => "text/csv", :filename => "cases #{start_date.to_s} to #{end_date.to_s}.csv", :disposition => 'attachment'    
  end

  def events
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    events = Event.accessible_by(current_ability).includes(:kase=>:customer, :user=>nil).where(:date => start_date..end_date)

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

  def get_kases_for_month
    #so, we want to be able to get a list of unduplicated customers
    #whose case was closed this month, and where this case was the
    #first case of the year
    
    start_date = Date.parse(params[:start_date])
    end_date = start_date.next_month

    successful = Disposition.find_by_name("Successful")

    kases_successfully_closed_this_month = Kase.where(["disposition_id=? and close_date between ? and ?", successful.id, start_date, end_date])

    kases_successfully_closed_this_month = filter_by_funding_source(kases_successfully_closed_this_month)

    #compute the fiscal year start date

    fy = start_date.year
    if start_date.month <= 6
      fy -= 1
    end
    fy_start_date = Date.new(fy, 7, 1)

    possibly_prior_kases_this_year = Kase.accessible_by(current_ability).where(["close_date < ? and close_date > ?", start_date, fy_start_date])

    possibly_prior_kases_this_year = filter_by_funding_source(possibly_prior_kases_this_year)

    #now, organize the prior cases by customer id
    priors_by_customer_id = {}
    for kase in possibly_prior_kases_this_year
      if ! priors_by_customer_id.member?(kase.customer_id)
        priors_by_customer_id[kase.customer_id] = []
      end
      priors_by_customer_id[kase.customer_id] << kase
    end

    kases = []
    for kase in kases_successfully_closed_this_month
      #figure out if there was a prior this year
      priors = priors_by_customer_id[kase.customer_id] || []
      bad = false
      for prior in priors
        next if prior == kase
        next if prior.open_date > kase.open_date
        bad = true
        break
      end
      next if bad
      kases << kase
    end
    kases
  end

  def get_kases_for_year
    successful = Disposition.find_by_name("Successful")

    year = params[:year].to_i || Date.today.year

    fy_start_date = Date.new(year, 7, 1)
    fy_end_date = Date.new(year + 1, 7, 1)

    if params[:funding_source_id].to_s != ''

      sql = "select k1.* from customers join kases k1 on (customers.id = k1.customer_id and k1.disposition_id = ? and k1.close_date between ? and ? and k1.funding_source_id=?)
    left outer join kases k2 on (customers.id = k2.customer_id and
      k1.close_date < k2.close_date and k2.disposition_id = ? and k2.close_date between ? and ? and k2.funding_source_id=?)
    where k2.id is null"
      kases = Kase.find_by_sql([sql, successful.id, fy_start_date, fy_end_date, params[:funding_source_id], successful.id, fy_start_date, fy_end_date, params[:funding_source_id]])
    else
      sql = "select k1.* from customers join kases k1 on (customers.id = k1.customer_id and k1.disposition_id = ? and k1.close_date between ? and ?)
    left outer join kases k2 on (customers.id = k2.customer_id and
      k1.close_date < k2.close_date and k2.disposition_id = ? and k2.close_date between ? and ?)
    where k2.id is null"
      kases = Kase.find_by_sql([sql, successful.id, fy_start_date, fy_end_date, successful.id, fy_start_date, fy_end_date])
    end
    kases = kases.find_all {|k| can? :read, k}
    kases
  end

  def filter_by_funding_source(query)
    if params[:funding_source_id].to_s != ''
      return query.where(:funding_source_id => params[:funding_source_id])
    else
      return query
    end
  end

  def compute_basic_results(kases)

    @exited_count = 0
    @work_related_vmr = 0
    @work_related_tpw = 0
    @non_work_related_vmr = 0
    @non_work_related_tpw = 0
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
end
