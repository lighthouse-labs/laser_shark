require 'spec_helper'

describe RegistrationForm do

	let(:student) { create(:student) }
	subject(:registration_form) { RegistrationForm.new(student) }

	describe '#validate' do

		context "with valid attributes" do
			it "is valid with just first_name, last_name, and email" do
				registration_form.validate(first_name: "Scar", last_name: "Face", email: "scar@faceb.ook")
				expect(registration_form).to be_valid
			end
			it "returns true" do
				result = registration_form.validate(attributes_for(:registration_form))
				expect(result).to be_true
			end
			it "does not update the student model" do
				expect do
					registration_form.validate(attributes_for(:registration_form, first_name: nil, last_name: "test"))
					student.reload
				end.not_to change(student, :last_name)
			end
		end

		context "with invalid attributes" do
			it "is invalid without first_name" do
				registration_form.validate("first_name" => "")
				expect(registration_form).to be_invalid
			end
			it "is invalid without last_name" do
				registration_form.validate("last_name" => "")
				expect(registration_form).to be_invalid
			end
			it "is invalid without email" do
				registration_form.validate("email" => "")
				expect(registration_form).to be_invalid
			end
			it "is invalid with invalid email" do
				registration_form.validate("email" => "invalidemail")
				expect(registration_form).to be_invalid
			end
		end

	end

	describe '#save' do
		context "with valid attributes" do
			it "updates the student model" do
				expect do
					registration_form.validate("email" => "e@e.com")
					registration_form.save
					student.reload
				end.to change(student, :email)
			end
		end

		context "with invalid attributes" do
			it "doesn't update the student model" do
				expect do
					registration_form.validate("email" => "")
					registration_form.save
					student.reload
				end.not_to change(student, :first_name)
			end
		end
	end

end
