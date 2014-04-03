class SessionsController < ApplicationController
	def create
		@current_student = Student.find_by_auth_hash(auth_hash_params)
		redirect_to root_url
	end

	protected

  def auth_hash_params
    request.env['omniauth.auth']
  end

end