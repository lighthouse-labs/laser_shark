class AddReferencesToAnswer < ActiveRecord::Migration
  def change
    add_reference :answers, :option, index: true, foreign_key: true
    add_reference :answers, :quiz_submission, index: true, foreign_key: true
  end
end
