# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :day_unit do
    name { Faker::Commerce.product_name }
    day { rand(1..50) }
    start_time { [900, 1100, 1500, 1900, 2200].sample }
    duration { rand(60..180) }
  end
end
