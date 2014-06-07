class Admin::UsersController < Admin::BaseController

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end
    def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      redirect_to admin_users_path
    else
      render :'admin/users/edit'
    end    
  end

  protected

  def user_params
    params.require(:user).permit(
      :type
    )
  end

end
