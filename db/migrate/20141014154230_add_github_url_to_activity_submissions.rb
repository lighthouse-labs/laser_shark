class AddGithubUrlToActivitySubmissions < ActiveRecord::Migration
  def change
    add_column :activity_submissions, :github_url, :string
  end
end
