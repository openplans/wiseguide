class CustomerImpairmentsController < ApplicationController
  before_filter :load_and_authorize_customer
  
  def new
    @impairments = Impairment.all
    @customer_impairment = CustomerImpairment.new :customer => @customer
  end
  
  def create
    @customer_impairment = CustomerImpairment.create(params[:customer_impairment])
    
    if @customer_impairment.save
      redirect_to @customer, :notice => 'Special consideration was successfully created.'
    else
      @impairments = Impairment.all
      render :action => :new
    end
  end
  
  def edit
    @customer_impairment = CustomerImpairment.find params[:id]
    @impairments         = Impairment.all
  end
  
  def update
    @customer_impairment = CustomerImpairment.find params[:id]
    
    if @customer_impairment.update_attributes params[:customer_impairment]
      redirect_to @customer, :notice => 'Special consideration was successfully created.'
    else
      @impairments = Impairment.all
      render :action => :edit
    end
  end
  
  def destroy
    @customer_impairment = CustomerImpairment.find params[:id]
    @customer_impairment.destroy
    redirect_to @customer
  end
  
  private
  
  def load_and_authorize_customer
    @customer = params[:customer_id].present? ? Customer.find(params[:customer_id]) : CustomerImpairment.find(params[:id]).customer
    authorize! :edit, @customer
  end
  
end
