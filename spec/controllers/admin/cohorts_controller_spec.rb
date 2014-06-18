require 'spec_helper'

describe Admin::CohortsController do
  before :each do
    set_valid_auth
  end

  describe 'GET #index' do
    it 'assigns all cohorts to @cohorts' do
      cohorts = create_list(:cohort, 5)
      get :index
      expect(assigns(:cohorts)).to_not be_nil
      expect(assigns(:cohorts)).to match_array(cohorts)
    end

    it 'renders index template' do
      get :index
      expect(response).to render_template :index
    end
  end

end
