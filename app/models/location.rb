class Location < ActiveRecord::Base
  TIMEZONE_NAMES = ActiveSupport::TimeZone.all.map { |timezone| timezone.name }

  validates :name, presence: true
  validates :timezone, presence: true

  has_many :users
  has_many :cohorts
  has_many :programs

  before_destroy :has_cohorts?

  private

  def has_cohorts?
    errors.add :cohorts, 'Cannot Delete a location with active Cohorts.' if cohorts.blank?
    cohorts.blank?
  end
end