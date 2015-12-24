class Teacher < User

  has_many :feedbacks

  has_many :teaching_assistances, class_name: Assistance, foreign_key: :assistor_id

  scope :filter_by_location, -> (location_id) {
    includes(:location).
    where(locations: {id: location_id})
  }

  scope :filter_by_teacher, -> (teacher_id) {
    where(id: teacher_id)
  }

  validates :bio,             presence: true, length: { maximum: 1000 }
  validates :quirky_fact,     presence: true
  validates :specialties,     presence: true

  def self.filter_by(options)
    options.inject(all) do |result, (k, v)|
      attribute = k.gsub("_id", "")
      result = result.send("filter_by_#{attribute}", v)
    end
  end

  def self.mentors(location)
    where( {mentor: true} ).
    where( {location: location} )
  end

  def can_access_day?(day)
    true
  end

  def prepping?
    false
  end

  def prospect?
    false
  end

  def busy?
    self.teaching_assistances.currently_active.length > 0
  end


end
