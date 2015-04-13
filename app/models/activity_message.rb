class ActivityMessage < ActiveRecord::Base

  KINDS = ['Lecture Notes']

  belongs_to :activity
  belongs_to :user # message creator
  belongs_to :cohort # message creator

  default_scope { order(created_at: :desc) }

  scope :for_cohort, -> (cohort) { where(cohort_id: cohort.id) }

  validates :activity, presence: true
  validates :user, presence: true
  validates :cohort, presence: true

  validates :subject, presence: true, length: { maximum: 100 }
  validates :day, presence: true, format: { with: DAY_REGEX, allow_blank: true }

  validates :kind, presence: true
  validates :body, presence: true

  after_create :notify_cohort_students, if: :for_students?

  private

  def notify_cohort_students
    UserMailer.new_activity_message(self).deliver
  end
  

end
