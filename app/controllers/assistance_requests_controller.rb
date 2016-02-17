class AssistanceRequestsController < ApplicationController

  #before_action :selected_cohort_locations, only: [:index, :queue]
  before_filter :teacher_required, only: [ :index, :start_assistance, :end_assistance, :queue ]

  def index
    no_root =
    location_ids = Cohort.all.map(&:location_id).uniq
    @all_locations = Location.where("id IN (?)", location_ids).map do |l|
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
    ar = AssistanceRequest.new({
      requestor: current_user,
      reason: assistance_request_params[:reason]
    })

    if ar.save
      render json: ar
    else
      permission_denied
    end
  end

  def destroy
    ar = AssistanceRequest.find assistance_request_params[:id]
    if ar && ar.cancel
      head :ok, content_type: "text/html"
    else
      permission_denied
    end
  end

  def queue
    location = params[:location]

    my_active_assistances = Assistance.assisted_by(current_user).currently_active

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
