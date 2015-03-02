# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :assistance_request do
    association :requestor, factory: :user
  end
end
