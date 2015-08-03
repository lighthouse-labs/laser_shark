require 'spec_helper'

describe IncompleteActivitiesController do

  logged_in_user

  describe "GET #incomplete" do
    it "gets all incompleted assignments up until today" do
      current_user.cohort = Cohort.new name: "test_cohort", start_date: Date.today, code: 1
      current_user.save
      get :index
      expect(response).to render_template :index
    end
  end

end
