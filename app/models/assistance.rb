class Assistance < ActiveRecord::Base
  has_one :assistance_request
  belongs_to :assistor, :class => User

  before_create :set_start_at

  scope :currently_active, -> { where(:end_at => nil) }
  scope :order_by_start, -> { order(:start_at) }

  def end(notes)
    self.notes = notes
    self.end_at = Time.now
  end

  private

  def set_start_at
    self.start_at = Time.now
  end

end