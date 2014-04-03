class Cohort < ActiveRecord::Base
	validates :name, presence: true
end
