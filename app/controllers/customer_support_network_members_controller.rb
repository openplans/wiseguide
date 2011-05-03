class CustomerSupportNetworkMembersController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
  end

  def edit
  end

  def new
    @customer_support_network_member = CustomerSupportNetworkMember.new(:customer_id=>params[:customer_id])
  end

  def create
    @customer = Customer.find(params[:customer_support_network_member][:customer_id])
    authorize! :edit, @customer
    @customer_support_network_member = CustomerSupportNetworkMember.new(params[:customer_support_network_member])

    if @customer_support_network_member.save
      redirect_to(@customer_support_network_member, :notice => 'CustomerSupportNetworkMember was successfully created.') 
    else
      render :action => "new"
    end
  end

  def update
    @customer = Customer.find(params[:customer_support_network_member][:customer_id])
    authorize! :edit, @customer
    if @customer_support_network_member.update_attributes(params[:customer_support_network_member])
      redirect_to(@customer_support_network_member, :notice => 'CustomerSupportNetworkMember was successfully created.') 
    else
      render :action => "edit"
    end
  end

  def destroy
    @customer = @customer_support_network_member.customer
    @customer_support_network_member.destroy
    redirect_to(@customer)
  end

end
