class CreateStreams < ActiveRecord::Migration
  def change
    create_table :streams do |t|
      t.string :title
      t.string :description
      t.string :wowza_id

      t.timestamps
    end
  end
end
