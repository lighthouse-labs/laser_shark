class ActivitiesOutcome < ActiveRecord::Base
  belongs_to :activity
  belongs_to :outcome
end
