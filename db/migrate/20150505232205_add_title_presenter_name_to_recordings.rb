class AddTitlePresenterNameToRecordings < ActiveRecord::Migration
  def change
    add_column :recordings, :title, :string
    add_column :recordings, :presenter_name, :string
  end
end
