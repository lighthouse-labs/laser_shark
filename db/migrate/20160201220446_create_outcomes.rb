class CreateOutcomes < ActiveRecord::Migration
  def change
    create_table :outcomes do |t|
      t.string :text

      t.timestamps null: false
    end
  end
end
