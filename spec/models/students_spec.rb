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
end