require 'spec_helper'

describe DayUnit do

  it "has a valid factory" do
    expect(build(:day_unit)).to be_valid
  end

  it "should be invalid without name" do
    day_unit = build(:day_unit, name: nil)
    expect(day_unit).to be_invalid
    expect(day_unit).to have(1).errors_on(:name)
  end

  it "should be invalid without day" do
    day_unit = build(:day_unit, day: nil)
    expect(day_unit).to be_invalid
    expect(day_unit).to have(1).errors_on(:day)
  end


end
