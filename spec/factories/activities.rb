# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activity do
    name { Faker::Commerce.product_name }
    day { "w#{rand(1..8)}d#{rand(1..5)}" }
    start_time { [900, 1100, 1500, 1900, 2200].sample }
    duration { rand(60..180) }
    type { "Assignment" }
  end

  factory :activity_assignment, class: Activity do
    type { "Assignment" }
    instructions { "Do something awesome" }
    duration { 60 }
  end
end
