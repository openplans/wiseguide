class DispositionsController < ApplicationController
  load_and_authorize_resource
  def index
    @dispositions = Disposition.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dispositions }
    end
  end

  # GET /dispositions/1
  # GET /dispositions/1.xml
  def show
    @disposition = Disposition.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @disposition }
    end
  end

  # GET /dispositions/new
  # GET /dispositions/new.xml
  def new
    @disposition = Disposition.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @disposition }
    end
  end

  # GET /dispositions/1/edit
  def edit
    @disposition = Disposition.find(params[:id])
  end

  # POST /dispositions
  # POST /dispositions.xml
  def create
    @disposition = Disposition.new(params[:disposition])

    respond_to do |format|
      if @disposition.save
        format.html { redirect_to(@disposition, :notice => 'Disposition was successfully created.') }
        format.xml  { render :xml => @disposition, :status => :created, :location => @disposition }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @disposition.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /dispositions/1
  # PUT /dispositions/1.xml
  def update
    @disposition = Disposition.find(params[:id])

    respond_to do |format|
      if @disposition.update_attributes(params[:disposition])
        format.html { redirect_to(@disposition, :notice => 'Disposition was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @disposition.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dispositions/1
  # DELETE /dispositions/1.xml
  def destroy
    @disposition.destroy

    respond_to do |format|
      format.html { redirect_to(dispositions_url) }
      format.xml  { head :ok }
    end
  end
end
