class AddEvaluatesCodeToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :evaluates_code, :boolean
  end
end
