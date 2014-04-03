require 'spec_helper'

describe Student do
	
	it "should be valid with first_name, last_name, email" do
		student = Student.new(first_name: Faker::Company.name, last_name: Faker::Company.name, email: Faker::Internet.email)
		expect(student).to be_valid
	end

	it "shouldn't be invalid without first_name" do
		student = Student.new(last_name: Faker::Company.name, email: Faker::Internet.email)
		expect(student).to be_invalid
	end
	it "shouldn't be invalid without last_name" do
		student = Student.new(first_name: Faker::Company.name, email: Faker::Internet.email)
		expect(student).to be_invalid
	end
	it "shouldn't be invalid without email" do
		student = Student.new(first_name: Faker::Company.name, last_name: Faker::Company.name)
		expect(student).to be_invalid
	end
	it "shouldn't be invalid with invalid email" do
		student = Student.new(first_name: Faker::Company.name, last_name: Faker::Company.name, email: "invalid_email")
		expect(student).to be_invalid
	end
	it "shouldn't be invalid with invalid phone_number" do
		student = Student.new(first_name: Faker::Company.name, last_name: Faker::Company.name, email: Faker::Internet.email, phone_number: "invalid_phone")
		expect(student).to be_invalid
	end
end