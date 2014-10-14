class AddGitUrlToActivitySubmissions < ActiveRecord::Migration
  def change
    add_column :activity_submissions, :git_url, :string
  end
end
