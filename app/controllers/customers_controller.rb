class CustomersController < ApplicationController
  load_and_authorize_resource

  def index
    @customers = Customer.paginate :page => params[:page], :order => [:last_name, :first_name]
  end

  def show
    prep_edit
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


  def add_impairment
    @customer = Customer.find(params[:customer_impairment][:customer_id])
    authorize! :edit, @customer
    @customer_impairment = CustomerImpairment.create(params[:customer_impairment])
    @impairment = @customer_impairment.impairment
    render :layout=>nil
  end

  def delete_impairment
    @customer_impairment = CustomerImpairment.where(:customer_id=>params[:customer_id], :impairment_id=>params[:impairment_id])[0]
    @customer_impairment.destroy
    render :json=>{:action=>:destroy, :customer_id=>@customer_impairment.customer_id, :impairment_id=>@customer_impairment.impairment_id}
  end

  private
  def prep_edit
    @impairments = Impairment.all
    @ethnicities = Ethnicity.all
    @genders = ALL_GENDERS
  end
end
