FactoryGirl.define do
  factory :student, parent: :user, class: Student do
    association(:cohort)
  end
end
