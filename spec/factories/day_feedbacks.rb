# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :day_feedback do
    mood false
    title "MyString"
    text "MyText"
  end
end
