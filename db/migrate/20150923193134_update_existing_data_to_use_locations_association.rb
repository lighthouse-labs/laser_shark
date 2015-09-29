class UpdateExistingDataToUseLocationsAssociation < ActiveRecord::Migration
  def up
    Location.create!(name: 'Vancouver')
    Location.create!(name: 'Toronto')
    Location.create!(name: 'Kelowna')
    Location.create!(name: 'Whitehorse')
    Location.create!(name: 'Calgary')
    add_column :cohorts, :location_id, :integer
    rename_column :cohorts, :location, :location_old
    Student.all.each do |student|
      student.location = Location.find_by(name: student.cohort.location_old)
      student.save
    end
    Cohort.all.each do |cohort|
      cohort.location = Location.find_by(name: cohort.location_old)
      cohort.save
    end
    remove_column :cohorts, :location_old
  end

  def down 

  end
end
