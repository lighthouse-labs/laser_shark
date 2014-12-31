class Teacher < User

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
