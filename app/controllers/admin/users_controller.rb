class Admin::UsersController < Admin::BaseController

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

end
