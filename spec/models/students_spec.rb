require 'spec_helper'

describe Student do
	
	it "has a valid factory" do
  	expect(build(:student)).to be_valid
  end

	it "should be valid with just first_name, last_name, email" do
		student = Student.new(first_name: Faker::Company.name, last_name: Faker::Company.name, email: Faker::Internet.email)
		expect(student).to be_valid
	end

	it "should be invalid without first_name" do
		student = build(:student, first_name: nil)
		expect(student).to be_invalid
	end
	it "should be invalid without last_name" do
		student = build(:student, last_name: nil)
		expect(student).to be_invalid
	end
	it "should be invalid without email" do
		student = build(:student, email: nil)
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