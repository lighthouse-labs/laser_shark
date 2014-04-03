FactoryGirl.define do
  factory :student do
  	first_name Faker::Company.name
  	last_name Faker::Company.name
  	email Faker::Internet.email
  	sequence(:phone_number) { |n| "#{n%10}"*10 }
  	twitter Faker::Company.name
  	skype Faker::Company.name
  end
end