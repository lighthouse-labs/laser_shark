require 'spec_helper'

describe ProfilesController do

  logged_in_user

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
      patch :update, user: attributes_for(:user)
      expect(assigns(:form)).to be_a(RegistrationForm)
    end

    context "with valid attributes" do
      it "does save the attributes to user" do
        expect do
          patch :update, user: attributes_for(:user, first_name: "new")
          current_user.reload
        end.to change(current_user, :first_name)
      end

      it "redirects to root url" do
        patch :update, user: attributes_for(:user)
        expect(response).to redirect_to root_url
      end
    end

    context "with invalid attributes" do
      it "does not save the attributes to user" do
        expect do
          patch :update, user: attributes_for(:user, first_name: nil)
          current_user.reload
        end.not_to change(current_user, :first_name)
      end

      it "re-renders :edit" do
        patch :update, user: attributes_for(:user, first_name: nil)
        expect(response).to render_template :edit
      end
    end
  end

end
