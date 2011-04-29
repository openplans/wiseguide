class TripReasonsController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
  end

  def new
    @trip_reason = TripReason.new
  end

  def edit
    @trip_reason = TripReason.find(params[:id])
  end

  def create
    @trip_reason = TripReason.new(params[:trip_reason])

    if @trip_reason.save
      redirect_to(@trip_reason, :notice => 'Trip reason was successfully created.')
      render :action => "new"
    end
  end

  def update
    @trip_reason = TripReason.find(params[:id])
    
    if @trip_reason.update_attributes(params[:trip_reason])
        redirect_to(@trip_reason, :notice => 'Trip reason was successfully updated.') 
    else
      render :action => "edit" 
    end
  end

  def destroy
    @trip_reason = TripReason.find(params[:id])
    @trip_reason.destroy

    redirect_to(trip_reasons_url) 
  end
end
