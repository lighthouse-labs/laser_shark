class SwitchStudentFKeyBackToUserOnQuizSubmission < ActiveRecord::Migration
  def change
    remove_reference :quiz_submissions, :student, index: true
    add_reference :quiz_submissions, :user, index: true
  end
end
