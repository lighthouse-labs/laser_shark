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
  Cohort.create! name: "May, 2014", start_date: "May 05, 2014", code: "may2014"
  Cohort.create! name: "June, 2014", start_date: "June 02, 2014", code: "jun2014"
end

#activities_file = ENV['FILE'] || File.join(Rails.root, "db", "activities_seed.rb")
# if File.exists?(activities_file)
#   puts "Loading Activities seed file"
#   require(activities_file)
# else
#   puts "File #{activities_file} not found!"
# end
