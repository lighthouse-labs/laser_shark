class Assistance < ActiveRecord::Base
  has_one :assistance_request, dependent: :nullify
  belongs_to :assistor, :class_name => User
  belongs_to :assistee, :class_name => User
  has_one :feedback, as: :feedbackable, dependent: :destroy

  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 4, allow_nil: true }

  before_create :set_start_at
  after_create :send_create_socket_messages
  after_destroy :send_destroy_socket_messages

  scope :currently_active, -> {
    joins("LEFT OUTER JOIN assistance_requests ON assistance_requests.assistance_id = assistances.id").
    where("assistance_requests.canceled_at IS NULL AND assistances.end_at IS NULL")
  }
  scope :completed, -> { where('assistances.end_at IS NOT NULL') }
  scope :order_by_start, -> { order(:start_at) }
  scope :assisted_by, -> (user) { where(:assistor => user) }
  scope :assisting, -> (user) { where(:assistee => user) }

  RATING_BASELINE = 3

  def end(notes, rating = nil)
    self.notes = notes
    self.rating = rating
    self.end_at = Time.now
    self.save
    self.assistee.last_assisted_at = Time.now
    if assistance_request.instance_of?(CodeReviewRequest) && !rating.nil? && !assistee.code_review_percent.nil?
      assistee.code_review_percent += Assistance::RATING_BASELINE - rating
    end
    
    self.assistee.save.tap do
      self.create_feedback(student: self.assistee, teacher: self.assistor)
      send_notes_to_slack
      send_assistance_ended_socket_messages
    end
  end

  def to_json
    return {
      start_time: start_at,
      id: id,
      assistee: {
        avatar_url: assistee.avatar_url,
        full_name: assistee.full_name
      }
    }
  end

  def day
    CurriculumDay.new(self.start_at, self.assistee.cohort).to_s
  end

  private

  def set_start_at
    self.start_at = Time.now
  end

  def send_notes_to_slack
    post_to_slack(ENV['SLACK_CHANNEL'])
    post_to_slack(ENV['SLACK_CHANNEL_REMOTE']) if self.assistee.remote
  end

  def post_to_slack(channel)
    return if ENV['SLACK_TOKEN'].nil? || channel.nil?
    options = {
      username: self.assistor.github_username,
      icon_url: self.assistor.avatar_url,
      channel: channel
    }
    begin
      poster = Slack::Poster.new('lighthouse', ENV['SLACK_TOKEN'], options)
      poster.send_message("*Assisted #{self.assistee.full_name} for #{ ((self.end_at - self.start_at)/60).to_i } minutes*:\n #{self.notes}")
    rescue
    end
  end

  def send_create_socket_messages
    if self.assistance_request
      location_name = self.assistee.cohort.location.name
      
      Pusher.trigger(
        SocketService.get_formatted_channel_name("assistance", location_name),
        "received", {
          type: "AssistanceStarted",
          object: AssistanceSerializer.new(self, root: false).as_json
        }
      )

      Pusher.trigger(
        SocketService.get_formatted_channel_name("UserChannel", self.assistee_id),
        'received', {
          type: "AssistanceStarted",
          object: UserSerializer.new(self.assistor).as_json
        }
      )

      self.assistor.send_web_socket_busy
      Student.send_queue_update_in_location(location_name)
    end
  end

  def send_destroy_socket_messages
    location_name = self.assistee.cohort.location.name

    Pusher.trigger(
      SocketService.get_formatted_channel_name("assistance", location_name),
      "received", {
        type: "StoppedAssisting",
        object: AssistanceSerializer.new(self).as_json
      }
    )

    self.assistor.send_web_socket_available
    Student.send_queue_update_in_location(location_name)
  end

  def send_assistance_ended_socket_messages
    location_name = self.assistee.cohort.location.name
    
    Pusher.trigger(
      SocketService.get_formatted_channel_name("assistance", location_name),
      "received", {
        type: "AssistanceEnded",
        object: AssistanceSerializer.new(self, root: false).as_json
      }
    )
    
    Pusher.trigger(
      SocketService.get_formatted_channel_name("UserChannel", self.assistee_id),
       "received",
      { type: "AssistanceEnded" }
    )

    self.assistor.send_web_socket_available
  end


end
