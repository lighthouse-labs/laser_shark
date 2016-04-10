class AddReferencesToQuizSubmission < ActiveRecord::Migration
  def change
    add_reference :quiz_submissions, :quiz, index: true, foreign_key: true
    add_reference :quiz_submissions, :user, index: true, foreign_key: true
  end
end
