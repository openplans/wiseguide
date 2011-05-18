class KasesController < ApplicationController
  load_and_authorize_resource

  def index
    name_ordered = 'customers.last_name, customers.first_name'
    
    @my_open_kases = @kases.find(:all, :conditions=>["user_id = ?", current_user.id], :joins=>:customer, :order=> name_ordered)
    @other_open_kases = @kases.find(:all, :conditions=>["user_id != ? and user_id is not null", current_user.id], :joins=>:customer, :order=> name_ordered)

    @wait_list = @kases.find(:all, :conditions=>"user_id is null", :order=>'open_date')
  end

  def show
    prep_edit #because some things are editable from show(?)
  end

  def edit
    prep_edit
  end

  def new
    in_progress = Disposition.find_by_name('In Progress')
    @kase = Kase.new(:customer_id=>params[:customer_id], :disposition_id=>in_progress.id)
    prep_edit
  end

  def create
    @kase = Kase.new(params[:kase])

    if @kase.save
      redirect_to(@kase, :notice => 'Case was successfully created.') 
    else
      prep_edit
      render :action => "new"
    end
  end

  def update

    if @kase.update_attributes(params[:kase])
      redirect_to(@kase, :notice => 'Case was successfully created.') 
    else
      prep_edit
      render :action => "edit"
    end
  end

  def destroy
    @kase.destroy
    redirect_to(kases_url)
  end

  def add_route
    @kase = Kase.find(params[:kase_route][:kase_id])
    authorize! :edit, @kase
    @kase_route = KaseRoute.create(params[:kase_route])
    @route = @kase_route.route
    render :layout=>nil
  end

  def delete_route
    @kase_route = KaseRoute.where(:kase_id=>params[:kase_id], :route_id=>params[:route_id])[0]
    @kase_route.destroy
    render :json=>{:action=>:destroy, :kase_id=>@kase_route.kase_id, :route_id=>@kase_route.route_id}
  end

  private
  def prep_edit
    @referral_types = ReferralType.accessible_by(current_ability)
    @users = User.accessible_by(current_ability)
    @dispositions = Disposition.accessible_by(current_ability)
    @funding_sources = FundingSource.accessible_by(current_ability)

    @kase_route = KaseRoute.new(:kase_id => @kase.id)
    @routes = Route.accessible_by(current_ability)

  end
end
