# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :assistance do
    association :assistor, factory: :user
    association :assistee, factory: :user
    association :assistance_request
  end
end
