require 'spec_helper'

describe NewStudentForm do

	describe "#submitting" do
		let(:student) { create(:student) }
		let(:new_student_form) { NewStudentForm.new(student) }

		context "with valid attributes" do
			it "is valid with just first_name, last_name, and email" do
				new_student_form.submit(first_name: "Scar", last_name: "Face", email: "scar@faceb.ook")
				expect(new_student_form).to be_valid
			end
			it "returns true" do
				result = new_student_form.submit(attributes_for(:new_student_form))
				expect(result).to be_true
			end
			it "updates the student model" do
				expect do
					new_student_form.submit(attributes_for(:new_student_form, first_name: "new"))
					student.reload
				end.to change(student, :first_name)
			end
		end

		context "with invalid attributes" do
			it "is invalid without first_name" do
				new_student_form.submit(attributes_for(:new_student_form, first_name: nil))
				expect(new_student_form).to be_invalid
			end
			it "is invalid without last_name" do
				new_student_form.submit(attributes_for(:new_student_form, last_name: nil))
				expect(new_student_form).to be_invalid
			end
			it "is invalid without email" do
				new_student_form.submit(attributes_for(:new_student_form, email: nil))
				expect(new_student_form).to be_invalid
			end
			it "is invalid with invalid email" do
				new_student_form.submit(attributes_for(:new_student_form, email: "bad_email"))
				expect(new_student_form).to be_invalid
			end
			it "is invalid with invalid phone_number" do
				new_student_form.submit(attributes_for(:new_student_form, phone_number: "bad_numberz"))
				expect(new_student_form).to be_invalid
			end
			it "returns false" do
				result = new_student_form.submit(attributes_for(:new_student_form, first_name: nil))
				expect(result).to be_false
			end
			it "does not update the student model" do
				expect do
					new_student_form.submit(attributes_for(:new_student_form, first_name: nil, last_name: "test"))
					student.reload
				end.not_to change(student, :last_name)
			end
		end

	end

end