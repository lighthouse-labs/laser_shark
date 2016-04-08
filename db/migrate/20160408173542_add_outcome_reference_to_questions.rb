class AddOutcomeReferenceToQuestions < ActiveRecord::Migration
  def change
    add_reference :questions, :outcome, index: true, foreign_key: true
  end
end
