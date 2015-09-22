class RegistrationForm < Reform::Form
  include Reform::Form::ActiveRecord

  property :first_name,   on: :user
  property :last_name,    on: :user
  property :email,  		  on: :user
  property :phone_number, on: :user
  property :twitter,  		on: :user
  property :skype,  			on: :user
  property :slack,  			on: :user
  property :custom_avatar, on: :user
  property :company_name, on: :user
  property :company_url,  on: :user
  property :bio,          on: :user
  property :quirky_fact,  on: :user
  property :specialties,  on: :user
  property :completed_registration, on: :user
  property :type,         on: :user

  validates :first_name,   presence: true
  validates :last_name,    presence: true
  validates :phone_number, presence: true
  validates :email,        email: true
  validates :bio,          presence: true,      length: { maximum: 1000 }, if: "type == 'Teacher'"
  validates :quirky_fact,  presence: true, if: "type == 'Teacher'"
  validates :specialties,  presence: true, if: "type == 'Teacher'"

end
