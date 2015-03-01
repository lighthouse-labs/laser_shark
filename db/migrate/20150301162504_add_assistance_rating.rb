class AddAssistanceRating < ActiveRecord::Migration
  def change
    add_column :assistances, :rating, :integer
  end
end
