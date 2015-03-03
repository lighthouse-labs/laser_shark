# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) can be set in the file .env file.

if Rails.env.development?
  Cohort.destroy_all
  Cohort.create! name: "May, 2014", start_date: "May 05, 2014", code: '123'
  Cohort.create! name: "June, 2014", start_date: "June 02, 2014", code: '456'
  Cohort.create! name: "Current", start_date: Date.current, code: '789'
end

100.times { FactoryGirl.create :activity }
50.times { FactoryGirl.create :user, type: 'Student', cohort: Cohort.all.sample }
