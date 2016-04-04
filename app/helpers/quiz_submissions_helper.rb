module QuizSubmissionsHelper
  def submission_score(submission)
    correct = submission.answers.joins(:option).where(options: {correct: true}).count
    questions = submission.quiz.try(:questions).try(:count) || '--'
    "#{correct} / #{questions}"
  end
end
