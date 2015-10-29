class Feedback < ActiveRecord::Base

  belongs_to :feedbackable, polymorphic: true
  belongs_to :student
  belongs_to :teacher

  scope :completed, -> { where("technical_rating IS NOT NULL AND style_rating IS NOT NULL") }
  scope :pending, -> { where("technical_rating IS NULL AND style_rating IS NULL") }
  scope :reverse_chronological_order, -> { order("updated_at DESC") }
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

  validates :technical_rating, presence: true, on: :update 
  validates :style_rating, presence: true, on: :update

  def self.filter_by(options)
    options.inject(all) do |result, (k, v)|
      attribute = k.gsub("_id", "")
      if attribute == 'completed?'
        result = self.filter_by_completed(v, result)
      else
        result = result.send("filter_by_#{attribute}", v)
      end    
    end
  end

  def self.filter_by_completed(value, result)
    if value == 'true'
      result = result.completed
    else
      result = result.pending
    end  
  end

end
