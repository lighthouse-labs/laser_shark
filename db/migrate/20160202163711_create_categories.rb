class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :text

      t.timestamps null: false
    end
  end
end
