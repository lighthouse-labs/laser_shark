class Teacher < User

  has_many :feedbacks

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
