class CustomersController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
  end

  def edit
    @impairments = Impairment.all
    @ethnicities = Ethnicity.all
    @genders = ALL_GENDERS
  end

  def new
    @impairments = Impairment.all
    @ethnicities = Ethnicity.all
    @genders = ALL_GENDERS
  end

  def create
    @customer = Customer.new(params[:customer])

    if @customer.save
      redirect_to(@customer, :notice => 'Customer was successfully created.') 
    else
      render :action => "new"
    end
  end

  def update

    if @customer.update_attributes(params[:customer])
      redirect_to(@customer, :notice => 'Customer was successfully created.') 
    else
      render :action => "new"
    end
  end

  def delete
    @customer.destroy
    redirect_to(impairments_url)
  end
end
