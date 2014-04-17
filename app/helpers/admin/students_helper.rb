module Admin::StudentsHelper

  def completed_registration?(student)
    student.completed_registration ? "YES" : "NO"
  end
end
