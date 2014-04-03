require 'spec_helper'

describe Cohort do
	it "has a valid factory" do
		expect(build(:cohort)).to be_valid
	end
 
  it "is valid with name" do
  	cohort = Cohort.new(name: "Fox")
  	expect(cohort).to be_valid
  end

  it "is invalid without a name" do
  	expect(build(:cohort, name: nil)).to have(1).errors_on(:name)
  end

end
