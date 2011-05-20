class EventsController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
  end

  def edit
    prep_edit
  end

  def new
    @event = Event.new(:user=>current_user, :kase_id=>params[:kase_id], :date_time=>DateTime.now)
    prep_edit
  end

  def create
    @kase = Kase.find(params[:event][:kase_id])
    authorize! :edit, @kase
    @event = Event.new(params[:event])

    if @event.save
      redirect_to(@event, :notice => 'Event was successfully created.') 
    else
      prep_edit
      render :action => "new"
    end
  end

  def update
    @kase = Kase.find(params[:event][:kase_id])
    authorize! :edit, @kase
    if @event.update_attributes(params[:event])
      redirect_to(@event, :notice => 'Event was successfully created.') 
    else
      prep_edit
      render :action => "edit"
    end
  end

  def destroy
    @event.destroy
    redirect_to(events_url)
  end

  private
  def prep_edit
    @event_types = EventType.accessible_by(current_ability)
    @funding_sources = FundingSource.accessible_by(current_ability)
    @users = User.accessible_by(current_ability)
  end

end
