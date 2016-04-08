class Question < ActiveRecord::Base

  has_many :options, dependent: :destroy

  accepts_nested_attributes_for :options, allow_destroy: true

  has_and_belongs_to_many :quizzes

  validates :question, presence: true

  # validates :activity, presence: true

  after_save :ensure_one_option


  private

  def ensure_one_option
    options.create(correct: true) if options.count == 0
  end
end
