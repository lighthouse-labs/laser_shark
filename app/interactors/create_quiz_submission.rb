class CreateQuizSubmission
  include Interactor

  def call
    @quiz = context.quiz
    @quiz_submission = @quiz.quiz_submissions.new(context.params)
    @quiz_submission.user = context.user
    @quiz_submission.initial = !previous_submissions?
    if !@quiz_submission.save
      context.fail!(error: "Failed to save")
    else
      context.quiz_submission = @quiz_submission
    end
    if @quiz_submission.initial
      result = CreateOutcomeResultsFromQuizSubmission.call(quiz_submission: @quiz_submission, user: context.user)
    end
  end

  private

  def previous_submissions?
    @quiz.quiz_submissions.where(user_id: context.user.id).any?
  end

end
