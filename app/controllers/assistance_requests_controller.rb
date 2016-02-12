class AssistanceRequestsController < ApplicationController

  #before_action :selected_cohort_locations, only: [:index, :queue]
  before_filter :teacher_required, only: [ :index, :destroy, :start_assistance,
                                           :end_assistance, :queue ]

  def subscribed
    Pusher.trigger format_channel_name("UserChannel", current_user.id),
                   'received', {
                      type: "UserConnected",
                      object: UserSerializer.new(current_user).as_json
                    }

    head :ok, content_type: "text/html"
  end

  def index
    no_root =
    location_ids = Cohort.all.map(&:location_id).uniq
    @all_locations = Location.where("id IN (?)", location_ids)
                             .map do |l|
                                LocationSerializer.new(l, root: false).as_json
                              end

    render component: "RequestQueue",
      props: {
        locations: @all_locations,
        user: UserSerializer.new(current_user).as_json
      },
      layout: "assistance"
  end

  def create
    ar = AssistanceRequest.new({requestor: current_user,
                               reason: assistance_request_params[:reason]})

    if ar.save

      location_name = current_user.cohort.location.name
      serialized_ar = AssistanceRequestSerializer.new(ar, root: false).as_json

      Pusher.trigger format_channel_name("assistance", location_name),
                     'received', {
                       type: "AssistanceRequest",
                       object: serialized_ar
                     }

      Pusher.trigger format_channel_name("UserChannel", current_user.id),
                     'received', {
                        type: 'AssistanceRequested',
                        object: current_user.position_in_queue
                      }

      head :ok, content_type: "text/html"

    else

      permission_denied

    end
  end

  def cancel
    ar = current_user.assistance_requests
                     .where(type: nil)
                     .open_or_in_progress_requests
                     .newest_requests_first
                     .first

    if ar && ar.cancel

      location_name = current_user.cohort.location.name
      serialized_ar = AssistanceRequestSerializer.new(ar, root: false).as_json

      Pusher.trigger format_channel_name("assistance", location_name),
                     'received', {
                        type: "CancelAssistanceRequest",
                        object: serialized_ar
                      }

      Pusher.trigger format_channel_name("UserChannel", current_user.id),
                     'received', {
                        type: 'AssistanceEnded'
                      }

      teacher_available(ar.assistance.assistor) if ar.assistance
      update_students_in_queue(ar.requestor.cohort.location.name)

      head :ok, content_type: "text/html"

    else

      permission_denied

    end
  end

  def queue
    location = params[:location]

    my_active_assistances = Assistance.assisted_by(current_user)
                                      .currently_active

    requests = AssistanceRequest.where(type: nil)
                                .open_requests
                                .oldest_requests_first
                                .requestor_cohort_in_locations([location])

    code_reviews = CodeReviewRequest.open_requests
                                    .oldest_requests_first
                                    .requestor_cohort_in_locations([location])

    all_students = Student.in_active_cohort
                          .active
                          .order_by_last_assisted_at
                          .cohort_in_locations([location])

    render json: RequestQueueSerializer.new({
                    assistances: my_active_assistances,
                    requests: requests,
                    code_reviews: code_reviews,
                    students: all_students
                 }).as_json
  end

  def status
    respond_to do |format|
      format.json {
        # Fetch most recent student initiated request
        ar = current_user.assistance_requests
                         .where(type: nil)
                         .newest_requests_first
                         .first
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

  def destroy
    ar = AssistanceRequest.find params[:id]
    status = ar.try(:cancel) ? 200 : 409

    respond_to do |format|
      format.json { render(:nothing => true, :status => status) }
      format.all { redirect_to(assistance_requests_path) }
    end
  end

  private
  def assistance_request_params
    params.permit(:reason)
  end

  def selected_cohort_locations
    locations_cookie = cookies[:cohort_locations]
    # The length thing is a hacky/lazy of getting around a JSON parse exception - KV
    #   http://stackoverflow.com/questions/8390256/a-json-text-must-at-least-contain-two-octets

    is_parsable = locations_cookie && locations_cookie.to_s.length >= 2

    @selected_locations = is_parsable ? JSON.parse(locations_cookie) : []
  end

  def teacher_required
    redirect_to(:root, alert: 'Not allowed') unless teacher?
  end

end
