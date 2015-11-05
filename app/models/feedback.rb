class Feedback < ActiveRecord::Base

  belongs_to :feedbackable, polymorphic: true
  belongs_to :student
  belongs_to :teacher

  scope :teacher_feedbacks, -> { where.not(teacher: nil) }
  scope :expired, -> { where("feedbacks.created_at < ?", Date.today-1) }
  scope :not_expired, -> { where("feedbacks.created_at >= ?", Date.today-1) }
  scope :completed, -> { where("technical_rating IS NOT NULL AND style_rating IS NOT NULL") }
  scope :pending, -> { where("technical_rating IS NULL AND style_rating IS NULL") }
  scope :reverse_chronological_order, -> { order("feedbacks.updated_at DESC") }
  scope :filter_by_student, -> (student_id) { where("student_id = ?", student_id) }
  scope :filter_by_teacher, -> (teacher_id) { where("teacher_id = ?", teacher_id) }

  scope :filter_by_location, -> (location_id) { 
    includes(student: :location).
    where(locations: {id: location_id}).
    references(:student, :location)
  }
  scope :filter_by_cohort, -> (cohort_id) {
    includes(student: :cohort).
    where(cohorts: {id: cohort_id}).
    references(:student, :cohort)
  }

   scope :filter_by_start_date, -> (date_str, location_id) { 
    Time.use_zone(Location.find(location_id).timezone) do 
      where("feedbacks.updated_at >= ?", Time.zone.parse(date_str).beginning_of_day.utc) 
    end
   }
   scope :filter_by_end_date, -> (date_str, location_id) { 
    Time.use_zone(Location.find(location_id).timezone) do 
      where("feedbacks.updated_at <= ?", Time.zone.parse(date_str).end_of_day.utc) 
    end
   }

  validates :technical_rating, presence: true, on: :update 
  validates :style_rating, presence: true, on: :update

  def self.filter_by(options)
    location_id = options[:location_id]
    options.inject(all) do |result, (k, v)|
      attribute = k.gsub("_id", "")
      if attribute == 'completed?'
        result = self.filter_by_completed(v, result)
      elsif attribute.include?('date')
        result = result.send("filter_by_#{attribute}", v, location_id)
      else
        result = result.send("filter_by_#{attribute}", v)
      end    
    end
  end

  def self.filter_by_completed(value, result)
    if value == 'true'
      result = result.completed
    elsif value == 'expired'
      result = result.expired.pending
    else
      result = result.pending
    end  
  end

end
