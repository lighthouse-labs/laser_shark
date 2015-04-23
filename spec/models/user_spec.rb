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

  describe '#being_assisted?' do
    it 'returns true if the user has an in progress assistance request' do
      ar = create(:assistance_request, canceled_at: nil, assistance: create(:assistance, end_at: nil))
      expect(ar.requestor.being_assisted?).to be_true
    end
    it 'returns false if the user only has completed assistance requests' do
      ar = create(:assistance_request, canceled_at: nil, assistance: create(:assistance, end_at: Date.current))
      expect(ar.requestor.being_assisted?).to be_false
    end
    it 'returns false if the user doesn\'t have any in progress assistance requests' do
      expect(create(:user).being_assisted?).to be_false
    end
  end

  describe '#current_assistor' do
    it 'returns a user who is currently assisting the user' do
      assistor = create(:user)
      ar = create(:assistance_request, canceled_at: nil, assistance: create(:assistance, end_at: nil, assistor: assistor))
      expect(ar.requestor.current_assistor).to eq(assistor)
    end
    it 'returns nil if the user does not have an in progress assistance request' do
      expect(create(:user).current_assistor).to be_nil
    end
  end

  describe '#waiting_for_assistance?' do
    it 'returns true if the user has an open assistance request' do
      ar = create(:assistance_request)
      expect(ar.requestor.waiting_for_assistance?).to be_true
    end
    it 'returns false if the user only has canceled assistance requests' do
      ar = create(:canceled_assistance_request)
      expect(ar.requestor.waiting_for_assistance?).to be_false
    end
    it 'returns false if the user doesn\'t have any in progress assistance requests' do
      expect(create(:user).waiting_for_assistance?).to be_false
    end
  end

end
