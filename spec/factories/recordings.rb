# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :recording do
    file_name { Faker::Number.number(10) + '.mp4' }
    recorded_at Time.now
    association :presenter, factory: :teacher
    association :cohort
    association :activity
    association :program
  end
end
