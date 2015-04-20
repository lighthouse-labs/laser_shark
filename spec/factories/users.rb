FactoryGirl.define do
  factory :user do
  	first_name   { Faker::Name.first_name }
  	last_name    { Faker::Name.last_name }
  	email        { Faker::Internet.safe_email }
  	phone_number { Faker::PhoneNumber.phone_number }
  	twitter      { Faker::Internet.user_name }
  	skype        { Faker::Internet.user_name }
  	slack        { Faker::Internet.user_name }
  	sequence(:uid, 1000)
  	sequence(:token, 2000)
    completed_registration true

    factory :user_for_auth do
      token "token"
      uid   "uid"
    end

    factory :unregistered_user do
      phone_number nil
      twitter      nil
      skype        nil
      slack        nil
      completed_registration nil
    end
  end
end
