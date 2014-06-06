class Activity < ActiveRecord::Base

  validates :name, presence: true, length: { maximum: 56 }
  validates :day, format: { with: /\A(w\dd\d)|(w\de)\z/ }

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

  protected

  def gist_id
    self.gist_url.split('/').last
  end

end
