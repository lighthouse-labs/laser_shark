class CreateCodeReviews < ActiveRecord::Migration
  def change
    create_table :code_reviews do |t|

      t.timestamps null: false
    end
  end
end
