require 'spec_helper'

describe User do

  it "has a valid factory" do
  	expect(build(:user)).to be_valid
  end

  it "should be valid with just uid, token" do
    user = User.new(uid: "uid", token: "token")
    expect(user).to be_valid
  end
  it "should be invalid without uid" do
    user = build(:user, uid: nil)
    expect(user).to be_invalid
  end
  it "should be invalid without token" do
    user = build(:user, token: nil)
    expect(user).to be_invalid
  end

  describe "#full_name" do
    it "returns a concatenation of first_name and last_name" do
      user = create(:user)
      expect(user.full_name).to eq "#{user.first_name} #{user.last_name}"
    end
  end

end
