require 'spec_helper'

describe Teacher do

  it "has a valid factory" do
    expect(build(:teacher)).to be_valid
  end

  it "is invalid without first name" do
    teacher = build(:teacher, first_name: nil)
    expect(teacher).to be_invalid
  end

  it "is invalid without last name" do
    teacher = build(:teacher, last_name: nil)
    expect(teacher).to be_invalid
  end

  it "is invalid without email" do
    teacher = build(:teacher, email: nil)
    expect(teacher).to be_invalid
  end
end