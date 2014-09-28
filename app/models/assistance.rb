class Assistance < ActiveRecord::Base
  has_one :assistance_request
  belongs_to :assistor, :class => User
  belongs_to :assistee, :class => User

  before_create :set_start_at

  scope :currently_active, -> { where(:end_at => nil) }
  scope :order_by_start, -> { order(:start_at) }
  scope :assisted_by, -> (user) { where(:assistor => user) }
  scope :assisting, -> (user) { where(:assistee => user) }

  def end(notes)
    self.notes = notes
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
    return if self.notes.blank?

    options = {
      :username => self.assistee.github_username,
      :icon_url => self.assistee.avatar_url,
      :channel => 'web-instructors'
    }

    poster = Slack::Poster.new("lighthouse", ENV["SLACK_TOKEN"], options)
    poster.send_message(self.notes)

  end
end