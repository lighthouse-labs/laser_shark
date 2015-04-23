require 'spec_helper'

describe HomeController do

	logged_in_user

  describe "GET 'show'" do
    xit "returns http success" do
      get 'show'

      # It should redirect to today path if logged in user
      expect(response).to redirect_to( day_path('today') )
    end
  end

end
