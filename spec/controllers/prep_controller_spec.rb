require 'spec_helper'

describe PrepController do

  # User needs to be logged in for prep page to show
  logged_in_user

  describe "GET 'show'" do
    it "returns http success" do
      get 'show'
      response.should be_success
    end
  end

end
