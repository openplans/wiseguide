class ContactsController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def edit
    prep_edit
  end

  def new
    @contact = Contact.new(:kase_id=>params[:kase_id], :date_time=>DateTime.now, :user => current_user)
    prep_edit
  end

  def create
    @kase = Kase.find(params[:contact][:kase_id])
    authorize! :edit, @kase
    @contact = Contact.new(params[:contact])
    @contact.user = current_user

    if @contact.save
      redirect_to(@kase, :notice => 'Contact was successfully created.') 
    else
      prep_edit
      render :action => "new"
    end
  end

  def update
    @kase = Kase.find(params[:contact][:kase_id])
    authorize! :edit, @kase
    if @contact.update_attributes(params[:contact])
      redirect_to(@kase, :notice => 'Contact was successfully updated.') 
    else
      prep_edit
      render :action => "edit"
    end
  end

  def destroy
    @contact.destroy

    redirect_to kase_path(@contact.kase)
  end

  private
  def prep_edit
    @contact_methods = ['Phone', 'Email', 'Meeting']
  end

end
