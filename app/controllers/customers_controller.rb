class CustomersController < ApplicationController
  load_and_authorize_resource

  def index
    @customers = Customer.paginate :page => params[:page], :order => [:last_name, :first_name]
  end

  def show
    prep_edit
  end
  
  def download_small_portrait
    send_file @customer.portrait.path(:small), :type => @customer.portrait_content_type, :disposition => 'inline'
  end

  def download_original_portrait
    send_file @customer.portrait.path(:original), :type => @customer.portrait_content_type
  end

  def new
    prep_edit
  end

  def create
    @customer = Customer.new(params[:customer])

    if @customer.save
      redirect_to(@customer, :notice => 'Customer was successfully created.') 
    else
      prep_edit
      render :action => "new"
    end
  end

  def update
    if @customer.update_attributes(params[:customer])
      redirect_to(@customer, :notice => 'Customer was successfully updated.') 
    else
      prep_edit
      render :action => "show"
    end
  end

  def destroy
    @customer.destroy
    redirect_to(customers_url)
  end
  
  def search
    term = params[:name].downcase.strip
    
    @customers = Customer.search(term).paginate( :page => params[:page], :order => [:last_name, :first_name])
    render :action => :index
  end

  private
  def prep_edit
    @ethnicities = Ethnicity.all
    @genders = ALL_GENDERS
  end
end
