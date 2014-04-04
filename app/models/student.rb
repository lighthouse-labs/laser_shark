class Student < ActiveRecord::Base
	validates_presence_of :uid, :token
	validates :email, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "must have valid email address"}, unless:  Proc.new { |n| email.nil? }
	validates :phone_number, length: {is: 10}, unless:  Proc.new { |n| phone_number.nil? }

	def self.find_by_auth_hash(auth_hash)
		where(uid: auth_hash["uid"]).first_or_create(token: auth_hash["credentials"]["token"])
	end

	def needs_setup?
		first_name.nil? || last_name.nil? || email.nil?
	end

end