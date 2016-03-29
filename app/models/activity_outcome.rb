class ActivityOutcome < ActiveRecord::Base
  belongs_to :activity
  belongs_to :outcome
end
