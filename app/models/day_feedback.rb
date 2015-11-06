class DayFeedback < ActiveRecord::Base
	
  belongs_to :student, foreign_key: :user_id
  
  validates :title, presence: true
  validates :text,  presence: true
  validates :day,   presence: true
  validates :mood,  presence: true

  scope :for_day, -> (day) { where(day: day.to_s) }
  scope :happy,   -> { where(mood: 'happy') }
  scope :ok,      -> { where(mood: 'ok') }
  scope :sad,     -> { where(mood: 'sad') }

  scope :from_cohort, -> (cohort) { joins(:student).where('users.cohort_id =? ', cohort.id) }
  scope :reverse_chronological_order, -> { order(created_at: :desc) }
  scope :archived, -> { where("archived_at IS NOT NULL") }
  scope :unarchived, -> { where("archived_at IS NULL") }

  scope :filter_by_program, -> (program_id) {
    includes(student: {cohort: :program}).
    where(programs: {id: program_id}).
    references(:student, :cohort, :program)
  }
  scope :filter_by_mood, -> (mood) { where(mood: mood) }
  scope :filter_by_day, -> (day) { where("day LIKE ?", day.downcase+"%") }
  scope :filter_by_location, -> (location_id) { 
    includes(student: :location).
    references(:student, :location).
    where(locations: {id: location_id}) unless location_id.blank?
  }
  scope :filter_by_start_date, -> (date_str, location_id) { 
    Time.use_zone(Location.find(location_id).timezone) do 
      where("day_feedbacks.created_at >= ?", Time.zone.parse(date_str).beginning_of_day.utc) 
    end
  }
  scope :filter_by_end_date, -> (date_str, location_id) { 
    Time.use_zone(Location.find(location_id).timezone) do 
      where("day_feedbacks.created_at <= ?", Time.zone.parse(date_str).end_of_day.utc) 
    end
  }

  after_create :notify_admin

  def archived?
    archived_at
  end

  def archive(user)
    self.archived_at = Time.now
    self.archived_by_user_id = user.id
  end

  def unarchive
    self.archived_at = nil
    self.archived_by_user_id = nil
  end

  private

  def notify_admin
    AdminMailer.new_day_feedback(self).deliver
  end

  def self.filter_by(options)
    location_id = options[:location_id]
    options.inject(all) do |result, (k, v)|
      attribute = k.gsub("_id", "")
      if attribute == 'archived?'
        result = self.filter_by_archived(v, result)
      elsif attribute.include?('date')
        result = result.send("filter_by_#{attribute}", v, location_id)
      else
        result = result.send("filter_by_#{attribute}", v)
      end   
    end
  end

  def self.filter_by_archived(value, result)
    if value == 'true'
      result = result.archived
    else
      result = result.unarchived
    end
  end

end
