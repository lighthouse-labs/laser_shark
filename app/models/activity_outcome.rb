class ActivityOutcome < ActiveRecord::Base
  belongs_to :activity
  belongs_to :outcome

  has_many :user_activity_outcomes
end
