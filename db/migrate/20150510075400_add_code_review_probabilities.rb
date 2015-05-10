class AddCodeReviewProbabilities < ActiveRecord::Migration
  def change
    add_column :activities, :code_review_percent, :integer, default: 60
    add_column :users, :code_review_percent, :integer, default: 80
  end
end
