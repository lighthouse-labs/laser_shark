require 'spec_helper'

describe Admin::StudentsController do
  before :each do
    set_valid_auth
  end
  describe 'GET #index' do
    it 'assigns all students to @students' do
      students = create_list(:student, 5)
      get :index 
      expect(assigns(:students)).to match_array(students)
    end

    it 'renders index template' do
      get :index
      expect(response).to render_template :index
    end
  end

end
