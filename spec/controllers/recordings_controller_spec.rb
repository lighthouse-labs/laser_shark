require 'spec_helper'

describe RecordingsController do
  describe "GET 'new'" do
    it "returns http success for a logged in Teacher" do
      login_as(create(:teacher))
      get 'new'
      expect(response).to be_success
    end

    it "returns http redirect for a logged in Student" do
      login_as(create(:student))
      get 'new'
      expect(response).to be_redirect
    end
  end
end
