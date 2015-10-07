class UpdateExistingDataToUseLocationsAssociation < ActiveRecord::Migration
  def up
    van = Location.find_or_create_by!(name: 'Vancouver')
    Location.find_or_create_by!(name: 'Toronto')
    Location.find_or_create_by!(name: 'Kelowna')
    Location.find_or_create_by!(name: 'Whitehorse')
    Location.find_or_create_by!(name: 'Calgary')
    
    add_column :cohorts, :location_id, :integer
    rename_column :cohorts, :location, :location_old
    
    Student.all.each do |student|
      location = student.cohort ? student.cohort.location_old.capitalize.split : 'Vancouver'
      student.location = Location.find_by(name: location) || van
      Student.where(id: student.id).update_all(location_id: location.id)
    end

    Cohort.all.each do |cohort|
      location = cohort.location_old.capitalize.split
      location = Location.find_by(name: location) || van
      Cohort.where(id: cohort.id).update_all(location_id: location.id)
    end

    remove_column :cohorts, :location_old
  end

  def down 

  end
end
