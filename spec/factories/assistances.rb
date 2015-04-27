# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :assistance do
    association :assistor, factory: :teacher
    association :assistee, factory: :student
    association :assistance_request
  end
end
