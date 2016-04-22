class QuizActivity < Activity
  belongs_to :quiz

  validates :quiz, presence: true

end
