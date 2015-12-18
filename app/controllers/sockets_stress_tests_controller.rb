class SocketsStressTestsController < ApplicationController
  skip_before_action :authenticate_user, only: [:index]
  before_action :authenticate_test_header

  def index
    @current_user = Cohort.is_active.order("RANDOM()").first.students.active.order("RANDOM()").first
    session[:user_id] = @current_user.id
    cookies.signed[:user_id] = @current_user.id
    redirect_to(:root)
  end

  private

  def authenticate_test_header
    redirect_to(:root, alert: 'Not allowed') unless params[:sockets_stress_token] == "sockets4321" #request.headers["HTTP_SOCKETS_STRESS_TOKEN"] == 'sockets4321'
  end
end
