class ItemOutcome < ActiveRecord::Base
  belongs_to :item, polymorphic: true
  belongs_to :outcome

  has_many :outcome_results, as: :source

end
