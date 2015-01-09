class AddTypeToAssitanceRequest < ActiveRecord::Migration
  def change
    add_column :assistance_requests, :type, :string
  end
end
