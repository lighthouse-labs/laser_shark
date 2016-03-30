class RenameSubmissionToQuizSubmission < ActiveRecord::Migration
  def change
    rename_table :submission, :quiz_submission
  end
end
