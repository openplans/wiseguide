class FundingSourcesController < ApplicationController
  load_and_authorize_resource
  # GET /funding_sources
  # GET /funding_sources.xml
  def index
    @funding_sources = FundingSource.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @funding_sources }
    end
  end

  # GET /funding_sources/1
  # GET /funding_sources/1.xml
  def show
    @funding_source = FundingSource.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @funding_source }
    end
  end

  # GET /funding_sources/new
  # GET /funding_sources/new.xml
  def new
    @funding_source = FundingSource.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @funding_source }
    end
  end

  # GET /funding_sources/1/edit
  def edit
    @funding_source = FundingSource.find(params[:id])
  end

  # POST /funding_sources
  # POST /funding_sources.xml
  def create
    @funding_source = FundingSource.new(params[:funding_source])

    respond_to do |format|
      if @funding_source.save
        format.html { redirect_to(@funding_source, :notice => 'Funding source was successfully created.') }
        format.xml  { render :xml => @funding_source, :status => :created, :location => @funding_source }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @funding_source.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /funding_sources/1
  # PUT /funding_sources/1.xml
  def update
    @funding_source = FundingSource.find(params[:id])

    respond_to do |format|
      if @funding_source.update_attributes(params[:funding_source])
        format.html { redirect_to(@funding_source, :notice => 'Funding source was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @funding_source.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /funding_sources/1
  # DELETE /funding_sources/1.xml
  def destroy
    @funding_source = FundingSource.find(params[:id])
    @funding_source.destroy

    respond_to do |format|
      format.html { redirect_to(funding_sources_url) }
      format.xml  { head :ok }
    end
  end
end
