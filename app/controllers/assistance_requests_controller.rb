class AssistanceRequestsController < ApplicationController

  before_filter :teacher_required, only: [:index, :destroy, :start_assistance, :end_assistance]

  def index
    @my_active_assistances = Assistance.currently_active.assisted_by(current_user)
    @requests = AssistanceRequest.where(type: nil).open_requests.oldest_requests_first
    @code_reviews = CodeReviewRequest.open_requests.oldest_requests_first
    @all_students = Student.in_active_cohort.active.order_by_last_assisted_at

    respond_to do |format|
      format.json {
        @obj = {
          active_assistances: @my_active_assistances.all.to_json(:include => {:assistee => { :include => [:cohort] }, :assistance_request => {:include => :activity_submission}}),
          requests: @requests.all.to_json(:include => { requestor: { :include => [:cohort] } }),
          code_reviews: @code_reviews.all.to_json(:include => { :requestor => { :include => [:cohort] }, :activity_submission => {} }),
          all_students: @all_students.all.to_json(:include => [:cohort])
        }
        render json: @obj
      }
      format.all { render :index, layout: "assistance" }
    end
  end

  def status
    respond_to do |format|
      format.json {
        # Fetch most recent student initiated request
        ar = current_user.assistance_requests.where(type: nil).newest_requests_first.first
        res = {}
        if ar.try(:open?)
          res[:state] = :waiting
          res[:position_in_queue] = ar.position_in_queue
        elsif ar.try(:in_progress?)
          res[:state] = :active
          res[:assistor] = {
              id: ar.assistance.assistor.id,
              first_name: ar.assistance.assistor.first_name,
              last_name: ar.assistance.assistor.last_name
          }
        else
          res[:state] = :inactive
        end
        render json: res
      }
      format.all { redirect_to(assistance_requests_path) }
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
    ar = current_user.assistance_requests.where(type: nil).open_requests.newest_requests_first.first
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
