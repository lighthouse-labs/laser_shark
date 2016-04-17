class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :name
      t.string :slug
      t.boolean :public, default: false

      t.timestamps null: false
    end
  end
end
