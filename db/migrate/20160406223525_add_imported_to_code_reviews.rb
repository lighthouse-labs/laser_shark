class AddImportedToCodeReviews < ActiveRecord::Migration
  def change
    add_column :assistances, :imported, :boolean, :default => false
  end
end
