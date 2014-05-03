require 'spec_helper'

describe Activity do

  it "has a valid factory" do
    expect(build(:activity)).to be_valid
  end

  it "should be invalid without name" do
    activity = build(:activity, name: nil)
    expect(activity).to be_invalid
    expect(activity).to have(1).errors_on(:name)
  end

  it "should be invalid without day" do
    activity = build(:activity, day: nil)
    expect(activity).to be_invalid
    expect(activity).to have(1).errors_on(:day)
  end


end
