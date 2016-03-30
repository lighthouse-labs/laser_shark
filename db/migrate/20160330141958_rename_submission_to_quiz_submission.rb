class RenameSubmissionToQuizSubmission < ActiveRecord::Migration
  def change
    rename_table :submissions, :quiz_submissions
  end
end
