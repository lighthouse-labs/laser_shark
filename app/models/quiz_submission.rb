class QuizSubmission < ActiveRecord::Base

  belongs_to :user

  has_many :answers, dependent: :destroy

  belongs_to :quiz

  accepts_nested_attributes_for :answers

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
end
