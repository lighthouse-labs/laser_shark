class Admin::StudentsController < Admin::BaseController

  def update
    @student = Student.find(params[:id])

    if @student.update_attributes(student_params)
      redirect_to admin_users_path
    else
      render :edit
    end    
  end

  protected

  def student_params
    params.require(:student).permit(
      :type
    )
  end

end
