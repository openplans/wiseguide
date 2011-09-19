class EventsController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def edit
    prep_edit
  end

  def new
    @event = Event.new(:user=>current_user, :kase_id=>params[:kase_id], :date=>Date.today, :start_time => "08:00 AM", :end_time => "09:00AM")
    prep_edit
  end

  def create
    @kase = Kase.find(params[:event][:kase_id])
    authorize! :edit, @kase
    @event = Event.new(params[:event])

    if @event.save
      redirect_to(@kase, :notice => 'Event was successfully created.') 
    else
      prep_edit
      render :action => "new"
    end
  end

  def update
    @kase = Kase.find(params[:event][:kase_id])
    authorize! :edit, @kase
    if @event.update_attributes(params[:event])
      redirect_to(@kase, :notice => 'Event was successfully updated.') 
    else
      prep_edit
      render :action => "edit"
    end
  end

  def destroy
    @event.destroy
    redirect_to kase_url( @event.kase )
  end

  private
  def prep_edit
    @event_types = EventType.accessible_by(current_ability)
    @funding_sources = FundingSource.accessible_by(current_ability)
    @users = User.accessible_by(current_ability)
  end

end
