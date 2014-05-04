module UserAccountHelpers

  module Macros

  	def current_user(&user)
      let(:current_user, &user)
      before { login_as current_user }
    end

    def logged_out_user
      current_user { nil }
    end

    def logged_in_user
      current_user { create(:user_for_auth) }
    end

  end

  def login_as(user)
    @logged_in = true
    allow(controller).to receive(:current_user).and_return user
  end

  def logged_in?
    @logged_in ||= false
  end

end
