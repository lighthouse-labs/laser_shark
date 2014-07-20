zip_url = ENV['ZIP_URL']

require 'open-uri'
require 'zip'

puts "About to open #{zip_url}"
file = open(zip_url)

puts file.inspect
Zip::File.open(file) do |zip_file|
  zip_file.each do |entry|
    puts "Found Entry #{entry.name}"
    dest = File.join(File.dirname(__FILE__), "example", entry.name)
    puts "Extracting into #{dest}"
    entry.extract(dest)
  end
end

activities_file = File.join(File.dirname(__FILE__), "example", "activities_seed.rb")
require(activities_file)
