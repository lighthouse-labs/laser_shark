require 'spec_helper'

describe RegistrationsController do

  logged_in_user

  context "not registered" do
    before :each do
      allow(current_user).to receive(:completed_registration?).and_return(nil)
    end
    describe "GET #edit" do
      it "assigns a registration form to @form" do
        get :edit
        expect(assigns(:user)).to be_a(User)
      end
      it "renders :edit" do
        get :edit
        expect(response).to render_template :edit
      end
    end

    describe "PATCH #update" do
      it "assigns the registration form to @form" do
        patch :update, user: attributes_for(:user)
        expect(assigns(:user)).to be_a(User)
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

  describe "#must_be_unregistered" do
    describe "GET #edit" do
      it "redirects to root_url if current user has completed registration" do
        allow(current_user).to receive(:completed_registration?).and_return(true)
        get :edit
        expect(response).to redirect_to root_url
      end
      it "does not redirect if current user hasn't completed registration" do
        allow(current_user).to receive(:completed_registration?).and_return(false)
        get :edit
        expect(response).not_to redirect_to root_url
      end
    end
  end

end
