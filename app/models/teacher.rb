class Teacher < User

  has_many :feedbacks

  scope :in_locations, -> (locations) {
    joins("LEFT OUTER JOIN locations ON users.location_id = locations.id").
    where("users.type" => 'Teacher').
    where("locations.name" => locations)
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

end
