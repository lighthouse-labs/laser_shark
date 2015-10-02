class AddTagsToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :tags, :text
  end
end
