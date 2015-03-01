class AssistanceRequestsController < ApplicationController

  before_filter :teacher_required, only: [:index, :destroy, :start_assistance, :end_assistance]

  def index
    @my_active_assistances = Assistance.currently_active.assisted_by(current_user)
    @requests = AssistanceRequest.where(type: nil).open_requests.oldest_requests_first
    @code_reviews = AssistanceRequest.code_reviews.open_requests.oldest_requests_first
    @all_students = Student.in_active_cohort.active.order_by_last_assisted_at

    respond_to do |format|
      format.json {
        @obj = {
          active_assistances: @my_active_assistances.all.to_json(:include => {:assistee => {}, :assistance_request => {:include => :activity_submission}}),
          requests: @requests.all.to_json(:include => :requestor),
          code_reviews: @code_reviews.all.to_json(:include => [:requestor, :activity_submission]),
          all_students: @allStudents.all.to_json
        }
        render json: @obj
      }
      format.all { render :index, layout: "assistance" }
    end
  end

  def create
    ar = AssistanceRequest.new(:requestor => current_user)
    status = ar.save ? 200 : 400
    respond_to do |format|
      format.json { render(:nothing => true, :status => status) }
      format.all { redirect_to(assistance_requests_path) }
    end
  end

  def cancel
    ar = AssistanceRequest.oldest_open_request_for_user(current_user)
    status = ar.try(:cancel) ? 200 : 400

    respond_to do |format|
      format.json { render(:nothing => true, :status => status) }
      format.all { redirect_to(assistance_requests_path) }
    end
  end

  def destroy
    ar = AssistanceRequest.find params[:id]
    status = ar.try(:cancel) ? 200 : 400

    respond_to do |format|
      format.json { render(:nothing => true, :status => status) }
      format.all { redirect_to(assistance_requests_path) }
    end
  end

  def start_assistance
    ar = AssistanceRequest.find(params[:id].to_i)
    status = ar.start_assistance(current_user) ? 200 : 400

    respond_to do |format|
      format.json { render(:nothing => true, :status => status) }
      format.all { redirect_to(assistance_requests_path) }
    end
  end

  def end_assistance
    params.permit(:assistance).permit(:notes)

    ar = AssistanceRequest.find(params[:id].to_i)
    status = ar.end_assistance(params[:assistance][:notes]) ? 200 : 400

    respond_to do |format|
      format.json { render(:nothing => true, :status => status) }
      format.all { redirect_to(assistance_requests_path) }
    end
  end

  private

  def teacher_required
    redirect_to(:root, alert: 'Not allowed') unless teacher?
  end

end
