class AddCodeReviewToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :has_code_reviews, :boolean, :default => true
    @vancouver_location = Location.find_by(name: 'Vancouver')
    @vancouver_location.update(has_code_reviews: false) if @vancouver_location
  end
end
