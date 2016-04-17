class CreateContentRepositories < ActiveRecord::Migration
  def change
    create_table :content_repositories do |t|
      t.string :github_username
      t.string :github_repo

      t.timestamps null: false
    end
  end
end
