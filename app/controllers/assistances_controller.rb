class AssistancesController < ApplicationController

  before_filter :teacher_required

  # The creation of an Assistance is effected when
  #   1- The student made an AssistanceRequest
  #   2- TA presses the button `Start Assisting` for that same AssistanceRequest
  #
  def create
    data = assistances_params
    ar = AssistanceRequest.find(data[:request_id])

    # #start_assistance is responsible for Assistance#create
    if ar.start_assistance(current_user)
      head :ok, content_type: "text/html"
    else
      permission_denied
    end
  end

  def provide_offline
    data = assistances_params
    student = Student.find params[:student_id]
    assistance = Assistance.new(assistor: current_user, assistee: student, notes: data[:notes], rating: data[:rating], end_at: Time.now)
    
    if assistance.save
      head :ok, content_type: "text/html"
    else
      permission_denied
    end
  end

  # After the Assistance has been #created, the TA will provide metrics regarding
  # the assistance rendered and submit them by pressing the `End Assistance` button.
  def update
    data = assistances_params
    assistance = Assistance.find data[:id]
    assistance.end(data[:notes], data[:rating].to_i)
    
    head :ok, content_type: "text/html"
  end

  # After Assistance has been #created, when TA presses button `Cancel Assisting`
  # #destroy gets called.
  def destroy
    data = assistances_params
    assistance = Assistance.find data[:id]
    if assistance && assistance.destroy
      head :ok, content_type: "text/html"
    else
      permission_denied
    end
  end

  private

  def teacher_required
    redirect_to(:root, alert: 'Not allowed') unless teacher?
  end

  def assistances_params
    params.permit(:id, :request_id, :notes, :rating)
  end
end
