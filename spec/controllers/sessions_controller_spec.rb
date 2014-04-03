require 'spec_helper'

describe SessionsController do

	describe "GET #create" do
		context "student does not exist locally" do
			it "creates a new student" do
				expect do
					get :create, provider: "github", state: "state", code: "code"
				end.to change(Student, :count).by(1)
			end
		end
		context "student does exist locally" do
			it "does not create a new student" do
				create(:student, state: "state", code: "code")
				expect do
					get :create, provider: "github", state: "state", code: "code"
				end.not_to change(Student, :count)
			end
		end
		it "assigns student to @current_student" do
			student = create(:student, state: "state", code: "code")
			get :create, provider: "github", state: "state", code: "code"
			expect(assigns(:current_student)).to eq student
		end
		it "stores the github auth fields to the student model" do
			get :create, provider: "github", state: "state", code: "code"
			expect(assigns(:current_student).state).to eq "state"
			expect(assigns(:current_student).code).to eq "code"
		end
		it "redirect to root url" do
			get :create, provider: "github", state: "state", code: "code"
			expect(response).to redirect_to root_url
		end
	end

end
