class UserActivityOutcome < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity_outcome

  before_create :autopopulate_rating

  protected

  def autopopulate_rating
    if self.activity_outcome.activity.section
      # => TODO Make this dynamic
      self.rating = Prep.evaluate_rating(self)
    end
  end

end
