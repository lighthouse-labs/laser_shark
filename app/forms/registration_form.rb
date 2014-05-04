class RegistrationForm < Reform::Form
  include Reform::Form::ActiveRecord

  property :first_name,   on: :user
  property :last_name,    on: :user
  property :email,  		  on: :user
  property :phone_number, on: :user
  property :twitter,  		on: :user
  property :skype,  			on: :user

  property :completed_registration, on: :user

  validates :first_name,   presence: true
  validates :last_name,    presence: true
  validates :phone_number, presence: true
  validates :email,        email: true

end
