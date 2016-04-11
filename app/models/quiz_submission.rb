class QuizSubmission < ActiveRecord::Base

  belongs_to :user

  belongs_to :quiz

  has_many :answers, dependent: :destroy

  has_many :outcome_results, as: :source

  accepts_nested_attributes_for :answers

  scope :stats, -> {
    select('quiz_submissions.*', 'options.correct AS options_correct', 'COUNT(answers.id) AS answers_count')
      .group('quiz_submissions.id', 'options.correct')
      .joins('LEFT JOIN quizzes ON quizzes.id = quiz_submissions.quiz_id')
      .joins('LEFT JOIN answers ON answers.quiz_submission_id = quiz_submissions.id')
      .joins('LEFT JOIN options ON answers.option_id = options.id')
      .order('quiz_submissions.created_at', 'options.correct')
  }

  before_create :add_outcome_results

  before_validation on: :create do
    unless uuid
      self.uuid = SecureRandom.uuid
    end
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

  private

  def add_outcome_results
    if initial
      answers.each do |answer|
        if answer.option.correct
          outcome_results << OutcomeResult.new(user: current_user, outcome: answer.option.question.outcome, rating: 3)
        else
          outcome_results << OutcomeResult.new(user: current_user, outcome: answer.option.question.outcome, rating: 1)
        end
      end
      unless answers.count >= quiz.questions.count
        answer_question_ids = answers.map { |a| a.option.question.id }
        unanswered_questions = quiz.questions.select { |question| answer_question_ids.exclude? question.id }
        unanswered_questions.each { |question| outcome_results << OutcomeResult.new(user: current_user, outcome: question.outcome, rating: 1) }
      end
    end
  end
end
