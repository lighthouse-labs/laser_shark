class OutcomeResult < ActiveRecord::Base
  belongs_to :user
  belongs_to :outcome
  belongs_to :resultable, polymorphic: true

  before_validation :populate_source

  protected

  def populate_source
    self.source ||= self.resultable_type
  end
end
