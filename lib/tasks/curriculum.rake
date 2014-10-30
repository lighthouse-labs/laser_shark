task :import_curriculum => :environment do

  require 'open-uri'
  require 'zip'

  def current_directory
    File.expand_path(File.dirname(__FILE__))
  end

  zip_url = ENV['ZIP_URL']
  puts "About to open #{zip_url}"
  file = open(zip_url)

  puts file.inspect
  Zip::File.open(file) do |zip_file|
    zip_file.each do |entry|
      puts "Found Entry #{entry.name}"
      dest = File.join(current_directory, "curriculum", entry.name)
      puts "Extracting into #{dest}"
      entry.extract(dest)
    end
  end

  activities_file = File.join(current_directory, "curriculum", "activities_seed.rb")
  require(activities_file)

end
