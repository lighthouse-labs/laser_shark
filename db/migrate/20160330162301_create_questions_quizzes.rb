class CreateQuestionsQuizzes < ActiveRecord::Migration
  def change
    create_table :questions_quizzes, id: false do |t|
      t.belongs_to :question, index: true
      t.belongs_to :quiz, index: true
    end
  end
end
