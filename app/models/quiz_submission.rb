class QuizSubmission < ActiveRecord::Base

  belongs_to :user

  belongs_to :quiz

  has_many :answers, dependent: :destroy

  accepts_nested_attributes_for :answers

  scope :stats, -> {
    select('quiz_submissions.*', 'options.correct AS options_correct', 'COUNT(answers.id) AS answers_count')
      .group('quiz_submissions.id', 'options.correct')
      .joins('LEFT JOIN quizzes ON quizzes.id = quiz_submissions.quiz_id')
      .joins('LEFT JOIN answers ON answers.quiz_submission_id = quiz_submissions.id')
      .joins('LEFT JOIN options ON answers.option_id = options.id')
      .order('quiz_submissions.created_at', 'options.correct')
  }

  before_validation on: :create do
    unless uuid
      self.uuid = SecureRandom.uuid
    end
  end

  def other_submissions_by_user
    user.quiz_submissions.where(quiz_id: quiz_id).where.not(id: self.id)
  end

  def to_param
    uuid
  end

  def option_selected?(option)
    @memo ||= {}
    option_id = option.is_a?(Option) ? option.id : option
    unless @memo.has_key?(option_id)
      @memo[option_id] = answers.map(&:option_id).include?(option_id)
    end
    @memo[option_id]
  end

  def score
    answers.inject(0) { |sum, answer| answer.option && answer.option.correct ? sum + 1 : sum }
  end

  def self.average_correct
    correct_answer_submissions = self.select(&:options_correct)
    correct_submissions_count = [correct_answer_submissions.length, 1].max
    correct_answer_sum = correct_answer_submissions.map(&:answers_count).reduce(0, &:+)
    correct_answer_sum.to_f / correct_submissions_count.to_f
  end
end
