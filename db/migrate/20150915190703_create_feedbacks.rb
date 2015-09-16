class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :student_id
      t.integer :teacher_id
      t.integer :technical_rating
      t.integer :style_rating
      t.text :notes
      t.integer :feedbackable_id
      t.string :feedbackable_type

      t.timestamps
    end
  end
end
