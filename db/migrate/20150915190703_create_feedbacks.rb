class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :student_id
      t.integer :teacher_id
      t.integer :technical_rating
      t.integer :style_rating
      t.text :notes
      t.integer :reviewed_id
      t.string :reviewed_type

      t.timestamps
    end
  end
end
