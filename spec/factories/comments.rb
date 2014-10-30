# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    association(:user)
    association(:commentable)
    content Faker::Lorem.paragraph
  end
end
