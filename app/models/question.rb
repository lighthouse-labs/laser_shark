class Question < ActiveRecord::Base

  belongs_to :outcome

  has_many :options, dependent: :destroy

  accepts_nested_attributes_for :options, allow_destroy: true

  has_and_belongs_to_many :quizzes

  validates :question, presence: true

  # validates :activity, presence: true

  after_save :ensure_one_option

  scope :stats, -> (quiz) {
    question_stats = select('questions.*', 'options.correct AS options_correct', 'COUNT(answers.id) AS answers_count')
      .group('questions.id', 'options.correct')
      .joins('LEFT JOIN options ON questions.id = options.question_id')
      .joins('LEFT JOIN answers ON answers.option_id = options.id')
    if quiz
      question_stats = question_stats
        .where('answers.id IN (SELECT answers.id FROM answers JOIN quiz_submissions ON quiz_submissions.id = answers.quiz_submission_id WHERE quiz_submissions.quiz_id = ?)', quiz.id)
    end
    question_stats
  }

  private

  def ensure_one_option
    options.create(correct: true) if options.count == 0
  end
end
