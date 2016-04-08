class AddReferencesToActivity < ActiveRecord::Migration
  def change
    add_reference :activities, :quiz, index: true, foreign_key: true
  end
end
