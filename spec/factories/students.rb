FactoryGirl.define do
  factory :student do
  	first_name   { Faker::Name.first_name }
  	last_name    { Faker::Name.last_name }
  	email        { Faker::Internet.safe_email }
  	phone_number { Faker::PhoneNumber.phone_number }
  	twitter      { Faker::Internet.user_name }
  	skype        { Faker::Internet.user_name }
  	sequence(:uid, 1000)
  	sequence(:token, 2000)
    completed_registration true
    association(:cohort)

    factory :student_for_auth do
      token "token"
      uid   "uid"
    end

    factory :unregistered_student do
      phone_number nil
      twitter      nil
      skype        nil
      completed_registration nil
    end
  end
end
