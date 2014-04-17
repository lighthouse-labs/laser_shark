require 'spec_helper'

describe ProfilesController do

  logged_in_student

  describe "GET #edit" do
    it "assigns a registration form to @form" do
      get :edit
      expect(assigns(:form)).to be_a(RegistrationForm)
    end
    it "renders :edit" do
      get :edit
      expect(response).to render_template :edit
    end
  end

  describe "PATCH #update" do
    it "assigns the registration form to @form" do
      patch :update, student: attributes_for(:student, uid: current_student.uid, token: current_student.token)
      expect(assigns(:form)).to be_a(RegistrationForm)
    end
    context "with valid attributes" do
      it "does save the attributes to student" do
        expect do
          patch :update, student: attributes_for(:student, first_name: "new", uid: current_student.uid, token: current_student.token)
          current_student.reload
        end.to change(current_student, :first_name)
      end
      it "redirects to root url" do
        patch :update, student: attributes_for(:student, uid: current_student.uid, token: current_student.token)
        expect(response).to redirect_to root_url
      end
    end
    context "with invalid attributes" do
      it "does not save the attributes to student" do
        expect do
          patch :update, student: attributes_for(:student, first_name: nil, uid: current_student.uid, token: current_student.token)
          current_student.reload
        end.not_to change(current_student, :first_name)
      end
      it "re-renders :edit" do
        patch :update, student: attributes_for(:student, first_name: nil, uid: current_student.uid, token: current_student.token)
        expect(response).to render_template :edit
      end
    end
  end

end
