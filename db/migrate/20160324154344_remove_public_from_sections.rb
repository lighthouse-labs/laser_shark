class RemovePublicFromSections < ActiveRecord::Migration
  def change
    remove_column :sections, :public
  end
end
