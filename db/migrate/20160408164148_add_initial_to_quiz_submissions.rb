class AddInitialToQuizSubmissions < ActiveRecord::Migration
  def change
    add_column :quiz_submissions, :initial, :boolean
  end
end
