require 'spec_helper'

describe Admin::DashboardController do

  describe 'GET show' do

    describe "security" do
         
      it "fails with 401 Unauthorized without http auth creds" do 
        get :show        
        expect(response.code).to eq('401')
      end

      it "succeeds (http 200) with valid admin creds" do 
        set_valid_auth
        get :show
        expect(response).to be_success
      end

      it "fails with 401 Unauthorized with invalid admin creds" do 
        set_invalid_auth
        get :show
        expect(response.code).to eq('401')
      end
    end

    describe "show action" do
      
      before :each do
        set_valid_auth
      end
      
      it 'renders the show template' do
        # request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('admin', 'password')
        get :show
        expect(response).to render_template :show
      end

      it 'renders within the admin layout' do 
        # request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('admin', 'password')
        get :show
        expect(response).to render_template(layout: 'admin')
      end 
    end
  end

  # show action renders within the admin layout

end
