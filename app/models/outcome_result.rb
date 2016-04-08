class OutcomeResult < ActiveRecord::Base
  belongs_to :user
  belongs_to :outcome
  belongs_to :source, polymorphic: true

  before_validation :populate_source

  protected

  def populate_source
    self.source_name ||= self.resultable_type
  end
end
