class Admin::TeachersController < Admin::BaseController
  def update
    @teacher = Teacher.find(params[:id])

    if @teacher.update_attributes(teacher_params)
      redirect_to admin_users_path
    else
      render :'admin/teachers/edit'
    end    
  end

  protected

  def teacher_params
    params.require(:teacher).permit(
      :type
    )
  end


end
