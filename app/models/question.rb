class Question < ActiveRecord::Base

  has_many :options, dependent: :destroy

  accepts_nested_attributes_for :options, allow_destroy: true

  has_and_belongs_to_many :quizzes

  validates :question, presence: true

  # validates :activity, presence: true

  validate :only_one_correct_option

  def only_one_correct_option
    count = 0
    options.each do |option|
      count += 1 if option.correct
    end
    errors.add(:options, "can't have more than one correct option") if count > 1
    errors.add(:options, "must have at least one correct option") if count < 1
  end
end
