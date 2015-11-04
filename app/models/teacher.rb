class Teacher < User

  has_many :feedbacks

  scope :filter_by_location, -> (location_id) {
    includes(:location).
    where(locations: {id: location_id})
  }

  scope :filter_by_teacher, -> (teacher_id) {
    where(id: teacher_id)
  }

  def can_access_day?(day)
    true
  end

  def prepping?
    false
  end

  def prospect?
    false
  end

  def self.filter_by(options)
    options.inject(all) do |result, (k, v)|
      attribute = k.gsub("_id", "")
      result = result.send("filter_by_#{attribute}", v)
    end
  end

end
