class AddTagsToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :tag, :string
  end
end
