class Admin::StudentsController < Admin::BaseController

  def index
    @students = Student.all
  end

end
