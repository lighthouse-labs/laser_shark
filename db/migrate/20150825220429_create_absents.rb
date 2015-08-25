class CreateAbsents < ActiveRecord::Migration
  def change
    create_table :absents do |t|
      t.string :date
      t.references :student, index: true

      t.timestamps
    end
  end
end