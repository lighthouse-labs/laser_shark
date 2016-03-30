class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.string :day
      t.string :uuid

      t.timestamps null: false
    end
  end
end
