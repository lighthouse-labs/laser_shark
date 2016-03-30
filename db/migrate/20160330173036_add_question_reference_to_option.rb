class AddQuestionReferenceToOption < ActiveRecord::Migration
  def change
    add_reference :options, :question, index: true, foreign_key: true
  end
end
