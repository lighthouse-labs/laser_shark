class CreatePrograms < ActiveRecord::Migration
  def up
    create_table :programs do |t|
      t.string :name
      t.text :lecture_tips

      t.timestamps
    end

    p = Program.create!(name: 'placeholder')

    add_column :cohorts, :program_id, :integer
    add_index :cohorts, :program_id

    Cohort.update_all(program_id: p.id)
  end

  def down
    drop_table :programs
    remove_column :cohorts, :program_id
  end
end
