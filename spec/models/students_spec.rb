require 'spec_helper'

describe Student do

  it "has a valid factory" do
  	expect(build(:student)).to be_valid
  end

  it "should be valid with just uid, token" do
    student = Student.new(uid: "uid", token: "token")
    expect(student).to be_valid
  end
  it "should be invalid without uid" do
    student = build(:student, uid: nil)
    expect(student).to be_invalid
  end
  it "should be invalid without token" do
    student = build(:student, token: nil)
    expect(student).to be_invalid
  end

  describe "#full_name" do
    it "returns a concatenation of first_name and last_name" do
      student = create(:student)
      expect(student.full_name).to eq "#{student.first_name} #{student.last_name}"
    end
  end

end
