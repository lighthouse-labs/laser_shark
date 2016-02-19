class AddSelectedCohortToUsers < ActiveRecord::Migration
  def change
    add_column :users, :selected_cohort_id, :integer
  end
end
