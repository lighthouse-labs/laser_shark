# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activity_submission do
    association(:user)
    association(:activity)
    completed_at { Date.current }
  end
end
