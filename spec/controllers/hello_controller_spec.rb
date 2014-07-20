require 'spec_helper'

describe HelloController do

  describe "GET 'hi'" do
    it "returns http success" do
      get 'hi'
      response.should be_success
    end
  end

end
