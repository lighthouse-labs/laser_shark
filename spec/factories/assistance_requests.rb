# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :assistance_request do
    association :requestor, factory: :student

    factory :open_assistance_request do
      canceled_at nil
      assistance nil
    end

    factory :canceled_assistance_request do
      canceled_at Date.current
      assistance nil
    end

    factory :in_progress_assistance_request do
      canceled_at nil
      association :assistance, end_at: nil
    end

    factory :completed_assistance_request do
      canceled_at nil
      association :assistance, end_at: Date.current
    end
  end
end
