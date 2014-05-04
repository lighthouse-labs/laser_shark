require 'spec_helper'

describe HomeController do

	logged_in_user

  describe "GET 'show'" do
    it "returns http success" do
      get 'show'
      response.should be_success
    end
  end

end
