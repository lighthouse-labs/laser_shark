class CreateActivityMessages < ActiveRecord::Migration
  def change
    create_table :activity_messages do |t|
      
      t.belongs_to :user, index: true
      t.belongs_to :cohort, index: true
      t.belongs_to :activity, index: true
      
      t.string :kind, limit: 50

      t.string :day, limit: 5, index: true
      t.string :subject, limit: 1000
      
      t.text :body
      t.text :teacher_notes

      t.boolean :for_students

      t.timestamps
    end
  end
end
