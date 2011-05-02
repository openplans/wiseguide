class CasesController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
    prep_edit #because some things are editable from show(?)
  end

  def edit
    prep_edit
  end

  def new
    @case = Case.new(:customer_id=>params[:customer_id])
    prep_edit
  end

  def create
    @case = Case.new(params[:case])

    if @case.save
      redirect_to(@case, :notice => 'Case was successfully created.') 
    else
      prep_edit
      render :action => "new"
    end
  end

  def update

    if @case.update_attributes(params[:case])
      redirect_to(@case, :notice => 'Case was successfully created.') 
    else
      prep_edit
      render :action => "edit"
    end
  end

  def destroy
    @case.destroy
    redirect_to(cases_url)
  end

  def add_route
    @case = Case.find(params[:case_route][:case_id])
    authorize! :edit, @case
    @case_route = CaseRoute.create(params[:case_route])
    @route = @case_route.route
    render :layout=>nil
  end

  def delete_route
    @case_route = CaseRoute.where(:case_id=>params[:case_id], :route_id=>params[:route_id])[0]
    @case_route.destroy
    render :json=>{:action=>:destroy, :case_id=>@case_route.case_id, :route_id=>@case_route.route_id}
  end

  private
  def prep_edit
    @referral_types = ReferralType.accessible_by(current_ability)
    @users = User.accessible_by(current_ability)
    @dispositions = Disposition.accessible_by(current_ability)
    @funding_sources = FundingSource.accessible_by(current_ability)

    @case_route = CaseRoute.new(:case_id => @case.id)
    @routes = Route.accessible_by(current_ability)

  end
end
