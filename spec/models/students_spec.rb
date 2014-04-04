require 'spec_helper'

describe Student do
	
	it "has a valid factory" do
  	expect(build(:student)).to be_valid
  end

	it "should be valid with just uid, token" do
		student = Student.new(uid: "uid", token: "token")
		expect(student).to be_valid
	end
	it "should be invalid without uid" do
		student = build(:student, uid: nil)
		expect(student).to be_invalid
	end
	it "should be invalid without token" do
		student = build(:student, token: nil)
		expect(student).to be_invalid
	end
	it "should be invalid with invalid email" do
		student = build(:student, email: "invalid_email")
		expect(student).to be_invalid
	end
	it "should be invalid with invalid phone_number" do
		student = build(:student, phone_number: "invalid_phone")
		expect(student).to be_invalid
	end

	describe "#needs_setup?" do
		it "returns true when first_name is nil" do
			student = create(:student, first_name: nil)
			expect(student.needs_setup?).to be_true
		end
		it "returns true when last_name is nil" do
			student = create(:student, last_name: nil)
			expect(student.needs_setup?).to be_true
		end
		it "returns true when email is nil" do
			student = create(:student, email: nil)
			expect(student.needs_setup?).to be_true
		end
		it "returns false when first_name, last_name, email are non-nil" do
			student = create(:student)
			expect(student.needs_setup?).to be_false
		end
	end
end