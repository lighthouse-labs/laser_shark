require 'spec_helper'

describe Cohort do
	it "has a valid factory" do
		expect(build(:cohort)).to be_valid
	end

  it "is invalid without a name" do
  	expect(build(:cohort, name: nil)).to have(1).errors_on(:name)
  end

  it "is invalid without a start date" do
    expect(build(:cohort, start_date: nil)).to have(1).errors_on(:start_date)
  end  

end
