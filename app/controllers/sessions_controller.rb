class SessionsController < ApplicationController
	skip_before_action :authenticate, only: [:create]

	def create
		@current_student = Student.find_by_auth_hash(auth_hash_params)
		session[:student_id] = @current_student.id
		if @current_student.needs_setup?
			redirect_to new_student_path
		else
			redirect_to root_url
		end
	end

	protected

  def auth_hash_params
    request.env['omniauth.auth']
  end

end