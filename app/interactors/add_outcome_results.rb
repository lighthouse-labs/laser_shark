class AddOutcomeResults
  include Interactor

  def call
    @quiz_submission = context.quiz_submission
    if @quiz_submission.initial
      @quiz_submission.answers.each do |answer|
        if answer.option.correct
          @quiz_submission.outcome_results << OutcomeResult.new(user: current_user, outcome: answer.option.question.outcome, rating: 3)
        else
          @quiz_submission.outcome_results << OutcomeResult.new(user: current_user, outcome: answer.option.question.outcome, rating: 1)
        end
      end
      unless @quiz_submission.answers.count >= @quiz_submission.quiz.questions.count
        answer_question_ids = @quiz_submission.answers.map { |a| a.option.question.id }
        unanswered_questions = @quiz_submission.quiz.questions.select { |question| answer_question_ids.exclude? question.id }
        unanswered_questions.each { |question| outcome_results << OutcomeResult.new(user: current_user, outcome: question.outcome, rating: 1) }
      end
    end
    context.fail! unless @quiz_submission.save
  end
end
