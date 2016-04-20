class Quiz < ActiveRecord::Base

  QUESTIONS_PER_QUIZ = 5

  has_many :quiz_activities

  has_many :quiz_submissions, dependent: :nullify

  has_and_belongs_to_many :questions

  # validates :cohort, presence: true

  #validates :day, presence: true

  # validate do
  #   errors.add(:questions, "insufficient for a quiz; #{QUESTIONS_PER_QUIZ} needed") if questions.length < QUESTIONS_PER_QUIZ
  # end

  # before_validation on: :create do
  #   unless uuid
  #     self.uuid = SecureRandom.uuid
  #   end
  # end

end
