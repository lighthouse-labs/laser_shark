class Question < ActiveRecord::Base
  belongs_to :activity

  has_many :options, dependent: :destroy

  accepts_nested_attributes_for :options, allow_destroy: true

  has_and_belongs_to_many :quizzes

  validates :question, presence: true

  validates :activity, presence: true
end
