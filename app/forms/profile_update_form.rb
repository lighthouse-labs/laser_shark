# class ProfileUpdateForm

#   include ActiveModel::Model

#   attr_accessor :first_name, :last_name, :email, :phone_number, :twitter, :skype
#   validates :first_name, presence: true
#   validates :last_name, presence: true
#   validates :email, presence: true
#   validates :phone_number, presence: true 



#   def initialize(profile)
#     @profile = profile

#   end

#   def submit(params)
#     if valid?
#       @profile.update_attributes(params)
#       @profile.first_name = params[:first_name]

#     else
#       false
#     end
#   end
# end