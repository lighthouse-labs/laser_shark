require 'spec_helper'

describe RecordingsController do
  context 'logged in as teacher' do
    before :each do
      login_as(create(:teacher))
    end

    describe "GET 'new'" do
      it "returns http success" do
        get 'new'
        expect(response).to be_success
      end
    end
  end

  context 'logged in as student' do
    before :each do
      login_as(create(:student))
    end

    describe "GET 'new'" do
      it "returns http redirect" do
        get 'new'
        expect(response).to be_redirect
      end
    end
  end
end
