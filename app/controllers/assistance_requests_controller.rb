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

  # When the student is online and presses the button `Request Assistance`
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

      # According to https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html,
      # under section 10.2.2 201 created, it is allowed to send back a response
      # but: `The response SHOULD include an entity containing a list of resource
      #       characteristics and location(s) from which the user or user agent
      #       can choose the one most appropriate.`
      # In our current implementation, location does not make sense but has been
      # included to keep as close to the standard.
      render :json => serialized_ar, :status  => :created, :location => ''
    else

      permission_denied

    end
  end

  # When a TA removes assistance_request from queue or when student cancels
  # request. The cancellation on part of the student can happen on different
  # levels:
  #   -1 Before TA had a chance to initiate an assistance
  #   -2 After TA initiated an assistance
  def cancel
    ar = AssistanceRequest.find assistance_request_params[:id]
    if ar && ar.cancel

      location_name = ar.requestor.cohort.location.name
      serialized_ar = AssistanceRequestSerializer.new(ar, root: false).as_json

      Pusher.trigger format_channel_name("assistance", location_name),
                     "received", {
                        type: "CancelAssistanceRequest",
                        object: serialized_ar
                     }

      Pusher.trigger format_channel_name("UserChannel", ar.requestor_id),
                     'received',
                     { type: "AssistanceEnded" }

      update_students_in_queue(location_name)

      # In case scenario -2 applies, make TA available again.
      teacher_available(ar.assistance.assistor) if ar.assistance

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


  def render_offline
    data = assistances_params
    student = Student.find data["student_id"]
    assistance_request = AssistanceRequest.new ({
                           requestor: student,
                           reason: "Offline assistance requested"
                         })

    if assistance_request.save
      assistance_request.start_assistance(current_user)
      assistance = assistance_request.reload.assistance
      assistance.end(data["notes"], data["rating"])

      location_name = assistance.assistance_request
                                .requestor
                                .cohort
                                .location
                                .name

      Pusher.trigger format_channel_name("assistance", location_name),
                     "received", {
                       type: "OfflineAssistanceCreated",
                       object: UserSerializer.new(student).as_json
                     }
      head :ok, content_type: "text/html"
    else
      permission_denied
    end
  end

  # I assume that this was part of `polling` implementation and thus can be removed
  # def status
  #   respond_to do |format|
  #     format.json {
  #       # Fetch most recent student initiated request
  #       ar = current_user.assistance_requests
  #                        .where(type: nil)
  #                        .newest_requests_first
  #                        .first
  #       res = {}
  #       if ar.try(:open?)
  #         res[:state] = :waiting
  #         res[:position_in_queue] = ar.position_in_queue
  #       elsif ar.try(:in_progress?)
  #         res[:state] = :active
  #         res[:assistor] = {
  #             id: ar.assistance.assistor.id,
  #             first_name: ar.assistance.assistor.first_name,
  #             last_name: ar.assistance.assistor.last_name
  #         }
  #       else
  #         res[:state] = :inactive
  #       end
  #       render json: res
  #     }
  #     format.all { redirect_to(assistance_requests_path) }
  #   end
  # end

  private
  def assistance_request_params
    params.permit(:reason, :id)
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
