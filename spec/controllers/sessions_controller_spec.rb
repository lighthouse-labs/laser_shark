require 'spec_helper'

describe SessionsController do

  describe "GET #create" do
    before :each do
      request.env['omniauth.auth'] = GITHUB_OAUTH_HASH
    end
    context "user does not exist locally" do
      it "creates a new user" do
        expect do
          get :create, provider: "github"
        end.to change(User, :count).by(1)
      end
      it "redirects to registration page" do
        user = create(:user)
        get :create, provider: "github"
        expect(response).to redirect_to new_registration_path
      end
    end
    context "user does exist locally" do
      it "does not create a new user" do
        create(:user, uid: "uid", token: "token")
        expect do
          get :create, provider: "github"
        end.not_to change(User, :count)
      end
      it "redirect to root" do
        create(:user, uid: "uid", token: "token")
        get :create, provider: "github"
        expect(response).to redirect_to root_url
      end
    end
    it "sets user id in the sessions hash" do
      get :create, provider: "github"
      expect(session[:user_id]).to eq assigns(:current_user).id
    end
    it "assigns user to @current_user" do
      user = create(:user, uid: "uid", token: "token")
      get :create, provider: "github"
      expect(assigns(:current_user)).to eq user
    end
    it "stores the github auth fields to the user model" do
      get :create, provider: "github"
      expect(assigns(:current_user).uid).to eq "uid"
      expect(assigns(:current_user).token).to eq "token"
    end
  end

  describe "DELETE #destroy" do
    it "clears session" do
      delete :destroy
      expect(session[:user_id]).to be_nil
    end
    it "redirects to github session path" do
      delete :destroy
      expect(response).to redirect_to github_session_path
    end
  end

  context "registered user is logged in" do
    logged_in_user

    it "destroys user session when signing out" do
      delete :destroy
      expect(assigns(:current_user)).to eq nil
    end
  end



end
