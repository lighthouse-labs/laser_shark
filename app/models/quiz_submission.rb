class QuizSubmission < ActiveRecord::Base

  belongs_to :student

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
end
