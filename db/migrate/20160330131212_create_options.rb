class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.text :answer
      t.text :explanation
      t.boolean :correct

      t.timestamps null: false
    end
  end
end
