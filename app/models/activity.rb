class Activity < ActiveRecord::Base

  validates :name, presence: true, length: { maximum: 56 }
  validates :day, format: { with: /\A(w\dd\d)|(w\de)\z/, allow_blank: true }

  scope :chronological, -> { order(:start_time) }
  scope :for_day, -> (day) { where(day: day) }

  after_create :update_instructions_from_gist

  # Given the start_time and duration, return the end_time
  def end_time
    hours = start_time / 100
    minutes = start_time % 100
    duration_hours = duration / 60
    duration_minutes = duration % 60

    if duration_minutes + minutes >= 60
      hours += 1
      minutes = (duration_minutes + minutes) % 60
      duration_minutes = 0
    end

    return (hours + duration_hours) * 100 + (minutes + duration_minutes)
  end

  def update_instructions_from_gist
    return if !self.gist_url?
    gist = ActivityGist.new(self.gist_url)
    self.instructions = gist.activity_content
    self.save
  end

  def next
    Activity.where('start_time > ? AND day = ?', self.start_time, self.day).order(start_time: :asc).first
  end

  def previous
    Activity.where('start_time < ? AND day = ?', self.start_time, self.day).order(start_time: :desc).first
  end

end
