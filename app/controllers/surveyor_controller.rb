#confusingly, this handles both surveys and response sets
#due to the weirdness inherent in surveyor

module SurveyorControllerCustomMethods
  def self.included(base)
    # base.send :before_filter, :require_user   # AuthLogic
    # base.send :before_filter, :login_required  # Restful Authentication
    # base.send :layout, 'surveyor_custom'
  end


  # Actions (for responsesets)
  def new
    super
    @kase = Kase.find(params[:kase_id])
    @surveys = @surveys.keep_if {|survey| survey.inactive_at.nil?} if @surveys.present?
  end
  def create
    @kase = Kase.find(params[:kase_id])
    authorize! :manage, @kase
    super
    @response_set.update_attributes({:kase_id => @kase.id})
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

  def surveyor_finish
    kase_path @kase
  end

  def delete_response_set
    @response_set = ResponseSet.find_by_access_code(params[:response_set_code])
    authorize! :manage, @response_set
    @kase = @response_set.kase
    @response_set.destroy
    redirect_to @kase
  end

  # Actions for surveys
  def new_survey
    
  end

  def create_survey
    authorize! :manage, Survey
    survey_obj = JSON.parse(params[:survey])
    to_save = []
    ActiveRecord::Base.transaction do
        survey = Survey.new(:title=>survey_obj['title'], :active_at=>DateTime.now)
        survey.inactive_at = nil #no, really
        to_save.push survey
        for section_obj in survey_obj['sections']
          section = SurveySection.new(:title=>section_obj["title"], :survey=>survey)
          to_save.push section
          for question_obj in section_obj['questions']
            case question_obj["type"] 
            when "group"
              #deal with question groups
              if not question_obj["text"] or not question_obj["display_type"]
                flash[:alert] = "Malformed question %s" % question_obj
                return render :action=>:new_survey
              end
              question_group = QuestionGroup.new(:text=>question_obj["text"],
                                                 :display_type=>question_obj["display_type"])
              to_save.push question_group
              for grouped_question_obj in question_obj["questions"]
                question = parse_question(grouped_question_obj, to_save)
                question.question_group = question_group
                question.survey_section = section
              end
            else
              question = parse_question(question_obj, to_save)
              question.survey_section = section
            end
          end
        end
        for savee in to_save
          savee.save!
        end
    end
    redirect_to surveys_path
  end

  def index
    @surveys = Survey.all
  end

  def destroy
    @survey = Survey.find(params[:id])
    @survey.inactive_at = DateTime.now
    @survey.save!
    redirect_to surveys_path
  end

  def reactivate
    @survey = Survey.find(params[:survey_id])
    @survey.inactive_at = DateTime.now
    @survey.save!
    redirect_to surveys_path
  end
    
  private
  def parse_question(question_obj, to_save)
    question = Question.new(:text=>question_obj["title"], 
                            :pick=>question_obj["pick"])
    i = 1
    for answer in question_obj["answers"]
      answer = Answer.new(:question=>question, :text=>answer["text"], :display_order=>i, :response_class=>answer['response_class'])
      i += 1
      to_save.push answer
    end
    to_save.push question
    return question
  end
end

class SurveyorController < ApplicationController
  include Surveyor::SurveyorControllerMethods
  include SurveyorControllerCustomMethods
end
