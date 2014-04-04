class NewStudentForm
	include ActiveModel::Model
	ATTRIBUTES = [:first_name, :last_name, :email, :phone_number, :twitter, :skype]
	attr_accessor *ATTRIBUTES, :student
	validates_presence_of :first_name, :last_name, :email
	validates :email, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "must have valid email address"}, unless:  Proc.new { |n| email.nil? }
	validates :phone_number, length: {is: 10}, unless:  Proc.new { |n| phone_number.nil? }

	def initialize(student)
		@student = student
	end

	def submit(params)
		params.each do |attr, value|
      self.send("#{attr.to_s}=", value)
    end
    if valid?
    	@student.first_name = first_name
    	@student.last_name = last_name
    	@student.email = email
    	@student.phone_number = phone_number
    	@student.twitter = twitter
    	@student.skype = skype
    	@student.save
    else
    	false
    end
	end

	def new_record?
		@student.new_record?
	end

end