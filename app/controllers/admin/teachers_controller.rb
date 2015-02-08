class Admin::TeachersController < Admin::BaseController

  def index
    @teachers = Teacher.all
  end

  def show
  	@teacher = Teacher.find(params[:id])
  end 

	def edit
		@teacher = Teacher.find(params[:id])
	end 

	def update 
		@teacher = User.find(params[:id])
		# @model_name.attributes = params[:model_name]
		# @student.update_attributes(params[:user])
		@teacher.update_attributes(params.require(:user).permit(
			:skype, :last_name, :first_name, :phone_number, :twitter, :github_username, :cohort_id, :type, :custom_avatar))
		if @teacher.save && @teacher.type == "Teacher"
			redirect_to admin_teacher_path
		elsif @teacher.save 
			redirect_to admin_teacher_path
		else 
			redirect_to edit_admin_teacher_path
		end
	end 

	def destroy
	end 
end