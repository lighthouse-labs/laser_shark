class Admin::StudentsController < Admin::BaseController

  def index
    @students = Student.all
  end

  def show
  	@student = Student.find(params[:id])
  end 

	def edit
		@student = Student.find(params[:id])
	end 

	def update 
		binding.pry
		@student = User.find(params[:id])
		# @model_name.attributes = params[:model_name]
		# @student.update_attributes(params[:user])
		@student.update_attributes(params.require(:user).permit(
			:skype, :last_name, :first_name, :phone_number, :twitter, :github_username, :cohort_id, :type, :custom_avatar))
		if @student.save && @student.type == "Student"
			redirect_to admin_student_path
		elsif @student.save 
			redirect_to admin_students_path
		end
	end 

	def destroy

	end 
end
