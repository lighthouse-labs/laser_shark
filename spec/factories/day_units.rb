# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :day_unit do
    name "MyString"
    day 1
    start_time 1
    duration 1
  end
end
