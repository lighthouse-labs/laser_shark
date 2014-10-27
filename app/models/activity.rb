class Activity < ActiveRecord::Base

  validates :name, presence: true, length: { maximum: 56 }
  validates :duration, numericality: { only_integer: true }
  validates :start_time, numericality: { only_integer: true }
  validates :day, presence: true, format: { with: /\A(w\dd\d)|(w\de)\z/, allow_blank: true }

  scope :chronological, -> { order(:start_time) }
  scope :for_day, -> (day) { where(day: day) }

  after_create :update_instructions_from_gist

  has_many :activity_submissions

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
    if self.gist_url?
      github = Github.new
      gist = github.gists.get gist_id
      file = gist.files['README.md'] || gist.files.detect { |f| f.first.ends_with?('.md') }.try(:last)
      if readme = file.try(:content)
        self.instructions = readme
        self.save
      end
    end
  end

  def next
    Activity.where('start_time > ? AND day = ?', self.start_time, self.day).order(start_time: :asc).first
  end

  def previous
    Activity.where('start_time < ? AND day = ?', self.start_time, self.day).order(start_time: :desc).first
  end

  protected

  def gist_id
    self.gist_url.split('/').last
  end

end
