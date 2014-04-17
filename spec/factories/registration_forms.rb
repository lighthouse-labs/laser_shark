FactoryGirl.define do
  factory :registration_form do
    first_name   { Faker::Name.first_name }
  	last_name    { Faker::Name.last_name }
  	email        { Faker::Internet.safe_email }
  	phone_number { Faker::PhoneNumber.phone_number }
  	twitter      { Faker::Internet.user_name }
  	skype        { Faker::Internet.user_name }
  end
end
