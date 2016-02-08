class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string :text
      t.references :category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
