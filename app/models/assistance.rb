class Assistance < ActiveRecord::Base
  has_one :assistance_request
  belongs_to :assistor, :class => User
  belongs_to :assistee, :class => User

  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 4, allow_nil: true }

  before_create :set_start_at

  scope :currently_active, -> {
    joins("LEFT OUTER JOIN assistance_requests ON assistance_requests.assistance_id = assistances.id").
    where("assistance_requests.canceled_at IS NULL AND assistances.end_at IS NULL")
  }
  scope :order_by_start, -> { order(:start_at) }
  scope :assisted_by, -> (user) { where(:assistor => user) }
  scope :assisting, -> (user) { where(:assistee => user) }

  def end(notes, rating = nil)
    self.notes = notes
    self.rating = rating
    self.end_at = Time.now
    self.save
    self.assistee.last_assisted_at = Time.now
    self.assistee.save

    send_notes_to_slack
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

  private

  def set_start_at
    self.start_at = Time.now
  end

  def send_notes_to_slack
    return unless ENV['SLACK_TOKEN']
    post_to_slack(ENV['SLACK_CHANNEL']) if ENV['SLACK_CHANNEL']
    post_to_slack(ENV['SLACK_CHANNEL_REMOTE']) if self.assistee.remote && ENV['SLACK_CHANNEL_REMOTE']
  end

  def post_to_slack(channel)
    options = {
      username: self.assistor.github_username,
      icon_url: self.assistor.avatar_url,
      channel: channel
    }
    poster = Slack::Poster.new('lighthouse', ENV['SLACK_TOKEN'], options)
    poster.send_message("*Assisted #{self.assistee.full_name} for #{ ((self.end_at - self.start_at)/60).to_i } minutes*:\n #{self.notes}")
  end
end
