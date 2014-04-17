class AddStartDateToCohort < ActiveRecord::Migration
  def change
    add_column :cohorts, :start_date, :date
  end
end
