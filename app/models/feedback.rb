class Feedback < ActiveRecord::Base

  belongs_to :feedbackable, polymorphic: true
  belongs_to :activity, -> { where(feedbacks: {feedbackable_type: 'Activity'}) }, foreign_key: 'feedbackable_id'
  belongs_to :student
  belongs_to :teacher

  scope :curriculum_feedbacks, -> { where(teacher: nil) }
  scope :teacher_feedbacks, -> { where.not(teacher: nil) }
  scope :expired, -> { where("feedbacks.created_at < ?", Date.today-1) }
  scope :not_expired, -> { where("feedbacks.created_at >= ?", Date.today-1) }
  scope :completed, -> { where.not(rating: nil) }
  scope :pending, -> { where(rating: nil) }
  scope :reverse_chronological_order, -> { order("feedbacks.updated_at DESC") }
  scope :filter_by_student, -> (student_id) { where("student_id = ?", student_id) }
  scope :filter_by_teacher, -> (teacher_id) { where("teacher_id = ?", teacher_id) }
  scope :filter_by_day, -> (day) { 
    includes(:activity).
    where("day LIKE ?", day.downcase+"%").
    references(:activity)
  }
  scope :lecture, -> { teacher_feedbacks.where(feedbackable_type: ['Activity']) }
  scope :assistance, -> { where(feedbackable_type: 'Assistance') }
  scope :direct, -> { where(feedbackable_type: nil) }

  scope :filter_by_program, -> (program_id) {
    includes(student: {cohort: :program}).
    where(programs: {id: program_id}).
    references(:student, :cohort, :program)
  }

  scope :filter_by_student_location, -> (location_id) { 
    includes(student: :location).
    where(locations: {id: location_id}).
    references(:student, :location)
  }
  scope :filter_by_teacher_location, -> (location_id) { 
    includes(teacher: :location).
    where(locations: {id: location_id}).
    references(:teacher, :location)
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

  validates :rating, presence: true, on: :update 

  def self.filter_by(options)
    location_id = options[:teacher_location_id] || options[:student_location_id]
    options.inject(all) do |result, (k, v)|
      attribute = k.gsub("_id", "")
      if attribute == 'completed?'
        self.filter_by_completed(v, result)
      elsif attribute.include?('date')
        result.send("filter_by_#{attribute}", v, location_id)
      else
        result.send("filter_by_#{attribute}", v)
      end    
    end
  end

  def self.filter_by_completed(value, result)
    if value == 'true'
      result.completed
    elsif value == 'expired'
      result.expired.pending
    else
      result.pending
    end  
  end

  def self.average_rating
    average(:rating).to_f.round(2)
  end

  def self.to_csv
    student_attributes = ['first_name', 'last_name']
    feedbackable_attributes = ['name', 'day', 'type']
    feedback_attributes = ['rating','created_at']
    location_attributes = ['name']
    CSV.generate do |csv|
      csv << ['Student First Name', 'Student Last Name', 'Activity Name', 'Activity Day', 'Activity Type', 'Rating', 'Created Date', 'Location']
      all.each do |feedback|
        csv << (feedback.student.attributes.values_at(*student_attributes) + 
                feedback.feedbackable.attributes.values_at(*feedbackable_attributes) +
                feedback.attributes.values_at(*feedback_attributes) + 
                feedback.student.cohort.location.attributes.values_at(*location_attributes))
      end
    end
  end

end
