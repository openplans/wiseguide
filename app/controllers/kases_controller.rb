class KasesController < ApplicationController
  load_and_authorize_resource

  def index
    name_ordered = 'customers.last_name, customers.first_name'
    
    @my_open_kases = @kases.open.assigned_to(current_user).joins(:customer).order(name_ordered)
    @my_three_month_follow_ups = @kases.assigned_to(current_user).has_three_month_follow_ups_due.order(:close_date)
    @my_six_month_follow_ups = @kases.assigned_to(current_user).has_six_month_follow_ups_due.order(:close_date)
    @other_open_kases = @kases.open.not_assigned_to(current_user).joins(:customer).order(name_ordered)
    @other_three_month_follow_ups = @kases.not_assigned_to(current_user).has_three_month_follow_ups_due.order(:close_date)
    @other_six_month_follow_ups = @kases.not_assigned_to(current_user).has_six_month_follow_ups_due.order(:close_date)
    @wait_list = @kases.unassigned.order(:open_date)
  end

  def show
    prep_edit
  end

  def new
    in_progress = Disposition.find_by_name('In Progress')
    @kase = Kase.new(:customer_id=>params[:customer_id], :disposition_id=>in_progress.id)
    @kase.county = Kase::VALID_COUNTIES.fetch(Customer.find(params[:customer_id]).county,nil)
    prep_edit
  end

  def create
    @kase = Kase.new(params[:kase])

    if @kase.save
      redirect_to(@kase, :notice => 'Case was successfully created.') 
    else
      prep_edit
      render :action => "new"
    end
  end

  def update

    if @kase.update_attributes(params[:kase])
      redirect_to(@kase, :notice => 'Case was successfully updated.') 
    else
      prep_edit
      render :action => "show"
    end
  end

  def destroy
    @kase.destroy
    redirect_to(kases_url)
  end

  def add_route
    @kase = Kase.find(params[:kase_route][:kase_id])
    authorize! :edit, @kase
    @kase_route = KaseRoute.create(params[:kase_route])
    @route = @kase_route.route
    render :layout=>nil
  end

  def delete_route
    @kase_route = KaseRoute.where(:kase_id=>params[:kase_id], :route_id=>params[:route_id])[0]
    @kase_route.destroy
    render :json=>{:action=>:destroy, :kase_id=>@kase_route.kase_id, :route_id=>@kase_route.route_id}
  end

  private
  def prep_edit
    @referral_types = ReferralType.accessible_by(current_ability)
    @users = [User.new(:email=>'Unassigned')] + User.accessible_by(current_ability)
    @dispositions = Disposition.accessible_by(current_ability)
    @funding_sources = FundingSource.accessible_by(current_ability)

    @kase_route = KaseRoute.new(:kase_id => @kase.id)
    @routes = Route.accessible_by(current_ability)

  end
end
