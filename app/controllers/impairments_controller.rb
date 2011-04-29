class ImpairmentsController < ApplicationController
  # GET /impairments
  # GET /impairments.xml
  def index
    @impairments = Impairment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @impairments }
    end
  end

  # GET /impairments/1
  # GET /impairments/1.xml
  def show
    @impairment = Impairment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @impairment }
    end
  end

  # GET /impairments/new
  # GET /impairments/new.xml
  def new
    @impairment = Impairment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @impairment }
    end
  end

  # GET /impairments/1/edit
  def edit
    @impairment = Impairment.find(params[:id])
  end

  # POST /impairments
  # POST /impairments.xml
  def create
    @impairment = Impairment.new(params[:impairment])

    respond_to do |format|
      if @impairment.save
        format.html { redirect_to(@impairment, :notice => 'Impairment was successfully created.') }
        format.xml  { render :xml => @impairment, :status => :created, :location => @impairment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @impairment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /impairments/1
  # PUT /impairments/1.xml
  def update
    @impairment = Impairment.find(params[:id])

    respond_to do |format|
      if @impairment.update_attributes(params[:impairment])
        format.html { redirect_to(@impairment, :notice => 'Impairment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @impairment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /impairments/1
  # DELETE /impairments/1.xml
  def destroy
    @impairment = Impairment.find(params[:id])
    @impairment.destroy

    respond_to do |format|
      format.html { redirect_to(impairments_url) }
      format.xml  { head :ok }
    end
  end
end
