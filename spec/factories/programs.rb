# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :program do
    name { Faker::Name.name }
    recordings_folder { Faker::Number.number(10) }
    recordings_bucket { Faker::Number.number(10) }
  end
end
