require 'spec_helper'

describe SessionsController do

  describe "GET #create" do
    before :each do
      request.env['omniauth.auth'] = GITHUB_OAUTH_HASH
    end
    context "student does not exist locally" do
      it "creates a new student" do
        expect do
          get :create, provider: "github"
        end.to change(Student, :count).by(1)
      end
      it "redirects to registration page" do
        student = create(:student)
        get :create, provider: "github"
        expect(response).to redirect_to new_registration_path
      end
    end
    context "student does exist locally" do
      it "does not create a new student" do
        create(:student, uid: "uid", token: "token")
        expect do
          get :create, provider: "github"
        end.not_to change(Student, :count)
      end
      it "redirect to root" do
        create(:student, uid: "uid", token: "token")
        get :create, provider: "github"
        expect(response).to redirect_to root_url
      end
    end
    it "sets student id in the sessions hash" do
      get :create, provider: "github"
      expect(session[:student_id]).to eq assigns(:current_student).id
    end
    it "assigns student to @current_student" do
      student = create(:student, uid: "uid", token: "token")
      get :create, provider: "github"
      expect(assigns(:current_student)).to eq student
    end
    it "stores the github auth fields to the student model" do
      get :create, provider: "github"
      expect(assigns(:current_student).uid).to eq "uid"
      expect(assigns(:current_student).token).to eq "token"
    end
  end

  context "registered student is logged in" do
    logged_in_student 

    it "destroys student session when signing out" do
      delete :destroy
      expect(assigns(:current_student)).to eq nil
    end
  end


    
end
