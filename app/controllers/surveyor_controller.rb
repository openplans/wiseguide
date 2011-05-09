module SurveyorControllerCustomMethods
  def self.included(base)
    # base.send :before_filter, :require_user   # AuthLogic
    # base.send :before_filter, :login_required  # Restful Authentication
    # base.send :layout, 'surveyor_custom'
  end

  # Actions
  def new
    super
    @kase = Kase.find(params[:kase_id])
  end
  def create
    @kase = Kase.find(params[:kase_id])
    authorize! :manage, @kase
    super
  end
  def show
    super
  end
  def edit
    super
  end
  def update
    @response_set = ResponseSet.find_by_access_code(params[:response_set_code])
    @kase = @response_set.kase_id
    authorize! :manage, @kase
    super
  end
  
  # Paths
  def surveyor_index
    # most of the above actions redirect to this method
    super # available_surveys_path
  end
  def surveyor_finish
    # the update action redirects to this method if given params[:finish]
    super # available_surveys_path
  end

  def delete_response_set
    @response_set = ResponseSet.find_by_access_code(params[:response_set_code])
    authorize! :manage, @response_set
    @kase = @response_set.kase
    @response_set.destroy
    redirect_to @kase
    
  end

end
class SurveyorController < ApplicationController
  include Surveyor::SurveyorControllerMethods
  include SurveyorControllerCustomMethods
end
