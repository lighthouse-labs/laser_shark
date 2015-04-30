require 'spec_helper'

describe Recording do
	it "has a valid factory" do
		expect(build(:recording)).to be_valid
	end

  it "is invalid without a program" do
  	expect(build(:recording, program: nil)).to have(1).errors_on(:program)
  end

  it "is invalid with a program that does not specify a recordings_bucket" do
  	expect(build(:recording, program: create(:program, recordings_bucket: nil))).to have(1).errors_on(:program)
  end
end
