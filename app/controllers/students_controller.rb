class StudentsController < ApplicationController

	def new
		@student = NewStudentForm.new(current_student)
	end

	def create
		@student = NewStudentForm.new(current_student)
		if @student.submit(student_params)
			redirect_to root_url
		else
			render :new
		end
	end

	private

	def student_params
		params.require(:student).permit(:first_name, :last_name, :email, :phone_number, :twitter, :skype)
	end

end