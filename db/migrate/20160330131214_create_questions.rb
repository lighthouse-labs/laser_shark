class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :question
      t.boolean :active
      t.integer :created_by_user_id

      t.timestamps null: false
    end
  end
end
