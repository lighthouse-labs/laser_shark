class ActivitySubmission < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity

  default_value_for :completed_at, allows_nil: false do
    Time.now
  end

  validates :user_id, uniqueness: { scope: :activity_id,
    message: "only one submission per activity" }

  validates :github_url, presence: :true

end
