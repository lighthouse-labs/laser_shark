class ActivitySubmission < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity

  validates_uniqueness_of :user_id, scope: :activity_id
end
