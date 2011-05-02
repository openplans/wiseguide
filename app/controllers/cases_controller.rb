class CasesController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
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

  def prep_edit
    @referral_types = ReferralType.accessible_by(current_ability)
    @users = User.accessible_by(current_ability)
    @dispositions = Disposition.accessible_by(current_ability)
    @funding_sources = FundingSource.accessible_by(current_ability)
  end
end
