class AddOrderToSections < ActiveRecord::Migration
  def change
    add_column :sections, :order, :integer
  end
end
