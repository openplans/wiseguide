class ReportsController < ApplicationController

  def index
    @funding_sources = [FundingSource.new(:id=>0, :name=>"all")] + FundingSource.accessible_by(current_ability) 
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

    possibly_prior_kases_this_year = Kase.where(["close_date < ? and close_date > ?", start_date, fy_start_date])

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
