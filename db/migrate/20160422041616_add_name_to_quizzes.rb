class AddNameToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :name, :string
  end
end
