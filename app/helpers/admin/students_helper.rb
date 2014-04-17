module Admin::StudentsHelper

  def completed_registration_formatter(student)
    student.completed_registration ? "YES" : "NO"
  end
end
