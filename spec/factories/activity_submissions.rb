# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activity_submission do
    association(:user)
    association(:activity, allow_submissions: false)
    completed_at { Date.current }
    factory :activity_submission_with_link do
      association(:activity)
      github_url { Faker::Internet.url(host: 'github.com') }
    end
  end
end
