class UpdateExistingDataToUseLocationsAssociation < ActiveRecord::Migration
  def up
    Location.find_or_create_by!(name: 'Vancouver')
    Location.find_or_create_by!(name: 'Toronto')
    Location.find_or_create_by!(name: 'Kelowna')
    Location.find_or_create_by!(name: 'Whitehorse')
    Location.find_or_create_by!(name: 'Calgary')
    add_column :cohorts, :location_id, :integer
    rename_column :cohorts, :location, :location_old
    Student.all.each do |student|
      if student.cohort
        location = student.cohort.location_old.capitalize.split
        student.location = Location.find_by(name: location)
        student.save
      else
        student.location = Location.find_by(name: 'Vancouver')
        student.save
      end
    end
    Cohort.all.each do |cohort|
      if cohort.code
        location = cohort.location_old.capitalize.split
        cohort.location = Location.find_by(name: location)
        cohort.save
      else
        cohort.code = Faker::Name.first_name.downcase
        location = cohort.location_old.capitalize.split
        cohort.location = Location.find_by(name: location)
        cohort.save
      end
    end
    remove_column :cohorts, :location_old
  end

  def down 

  end
end
