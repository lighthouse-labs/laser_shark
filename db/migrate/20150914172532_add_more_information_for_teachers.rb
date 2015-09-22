class AddMoreInformationForTeachers < ActiveRecord::Migration
  def change
    add_column :users, :company_name, :string
    add_column :users, :company_url, :string
    add_column :users, :bio, :text
    add_column :users, :quirky_fact, :string
    add_column :users, :specialties, :string
  end
end
