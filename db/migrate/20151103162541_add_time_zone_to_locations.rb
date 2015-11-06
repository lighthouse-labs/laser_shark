class AddTimeZoneToLocations < ActiveRecord::Migration
  def up
    add_column :locations, :timezone, :string
    @van = Location.find_by(name: 'Vancouver')
    @kel = Location.find_by(name: 'Kelowna')
    @wh = Location.find_by(name: 'Whitehorse')
    @van.timezone = 'Pacific Time (US & Canada)'
    @kel.timezone = 'Pacific Time (US & Canada)'
    @wh.timezone = 'Pacific Time (US & Canada)' 
    @van.save
    @kel.save
    @wh.save
    @tor = Location.find_by(name: 'Toronto')
    @tor.timezone = 'Eastern Time (US & Canada)'
    @tor.save
    @cal = Location.find_by(name: 'Calgary')
    @cal.timezone = 'Mountain Time (US & Canada)'
    @cal.save
  end

  def down
    remove_column :locations, :timezone
  end
end
