class AddTimeZoneToLocations < ActiveRecord::Migration
  def up
    add_column :locations, :timezone, :string

    if van = Location.find_by(name: 'Vancouver')
      van.timezone = 'Pacific Time (US & Canada)'
      van.save
    end

    if kel = Location.find_by(name: 'Kelowna')
      kel.timezone = 'Pacific Time (US & Canada)'
      kel.save  
    end

    if wh = Location.find_by(name: 'Whitehorse')
      wh.timezone = 'Pacific Time (US & Canada)'
      wh.save 
    end
    
    if tor = Location.find_by(name: 'Toronto')
      tor.timezone = 'Eastern Time (US & Canada)'
      tor.save
    end
    
    if cal = Location.find_by(name: 'Calgary')
      cal.timezone = 'Mountain Time (US & Canada)'
      cal.save
    end
  end

  def down
    remove_column :locations, :timezone
  end
end
