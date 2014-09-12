class AddAssisteeToAssistance < ActiveRecord::Migration
  def change
    add_column :assistances, :assistee_id, :integer
  end
end
