class SocketsStressTestsController < ApplicationController
  skip_before_action :authenticate_user, only: [:index]
  before_action :authenticate_test_header

  def index
    @current_user = Student.create!(
      uid: rand(1..1000), 
      token: rand(1..1000), 
      first_name: Faker::Name.first_name, 
      last_name: Faker::Name.last_name, 
      email: Faker::Internet.email,
      phone_number: Faker::PhoneNumber.phone_number,
      location_id: 2,
      cohort_id: 22,
      github_username: Faker::Name.first_name,
      completed_registration: true
    )
    session[:user_id] = @current_user.id
    cookies.signed[:user_id] = @current_user.id
    redirect_to(:root)
  end

  private

  def authenticate_test_header
    redirect_to(:root, alert: 'Not allowed') unless params[:sockets_stress_token] == "sockets4321" #request.headers["HTTP_SOCKETS_STRESS_TOKEN"] == 'sockets4321'
  end
end
