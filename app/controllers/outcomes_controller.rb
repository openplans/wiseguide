class OutcomesController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
  end

  def edit
    prep_edit
  end

  def new
    @outcome = Outcome.new(:kase_id=>params[:kase_id])
    prep_edit
  end

  def create
    @kase = Kase.find(params[:outcome][:kase_id])
    authorize! :edit, @kase
    @outcome = Outcome.new(params[:outcome])

    if @outcome.save
      redirect_to(@outcome, :notice => 'Outcome was successfully created.') 
    else
      prep_edit
      render :action => "new"
    end
  end

  def update
    @kase = Kase.find(params[:outcome][:kase_id])
    authorize! :edit, @kase
    if @outcome.update_attributes(params[:outcome])
      redirect_to(@outcome, :notice => 'Outcome was successfully created.') 
    else
      prep_edit
      render :action => "edit"
    end
  end

  def destroy
    @outcome.destroy
    redirect_to(outcomes_url)
  end

  private
  def prep_edit
    @trip_reasons = TripReason.accessible_by(current_ability)
  end

end
