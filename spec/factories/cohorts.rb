# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cohort do
    name { "Foxes" }
    start_date   { Date.today }
  end
end
