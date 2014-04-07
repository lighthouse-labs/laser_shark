class RegistrationForm < Reform::Form
	include Reform::Form::ActiveRecord

	property :first_name,   on: :student
	property :last_name,    on: :student
	property :email,  		  on: :student
	property :phone_number, on: :student
	property :twitter,  		on: :student
	property :skype,  			on: :student

	property :completed_registration, on: :student

	validates :first_name,   presence: true
	validates :last_name,    presence: true
	validates :phone_number, presence: true
	validates :email,        email: true

end
