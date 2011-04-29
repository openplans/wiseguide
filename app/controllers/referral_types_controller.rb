class ReferralTypesController < ApplicationController
  # GET /referral_types
  # GET /referral_types.xml
  def index
    @referral_types = ReferralType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @referral_types }
    end
  end

  # GET /referral_types/1
  # GET /referral_types/1.xml
  def show
    @referral_type = ReferralType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @referral_type }
    end
  end

  # GET /referral_types/new
  # GET /referral_types/new.xml
  def new
    @referral_type = ReferralType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @referral_type }
    end
  end

  # GET /referral_types/1/edit
  def edit
    @referral_type = ReferralType.find(params[:id])
  end

  # POST /referral_types
  # POST /referral_types.xml
  def create
    @referral_type = ReferralType.new(params[:referral_type])

    respond_to do |format|
      if @referral_type.save
        format.html { redirect_to(@referral_type, :notice => 'Referral type was successfully created.') }
        format.xml  { render :xml => @referral_type, :status => :created, :location => @referral_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @referral_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /referral_types/1
  # PUT /referral_types/1.xml
  def update
    @referral_type = ReferralType.find(params[:id])

    respond_to do |format|
      if @referral_type.update_attributes(params[:referral_type])
        format.html { redirect_to(@referral_type, :notice => 'Referral type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @referral_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /referral_types/1
  # DELETE /referral_types/1.xml
  def destroy
    @referral_type = ReferralType.find(params[:id])
    @referral_type.destroy

    respond_to do |format|
      format.html { redirect_to(referral_types_url) }
      format.xml  { head :ok }
    end
  end
end
