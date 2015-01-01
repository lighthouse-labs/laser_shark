class AddCodeToCohort < ActiveRecord::Migration
  def change
    add_column :cohorts, :code, :string
  end
end
