require 'spec_helper'

describe Assistance do

  it 'has a valid factory' do
    expect(build(:assistance)).to be_valid
  end

  it 'should be valid with a null rating' do
    assistance = build(:assistance, rating: nil)
    expect(assistance).to be_valid
  end

  it 'should be invalid with a rating out of range' do
    assistance = build(:assistance, rating: 0)
    expect(assistance).to be_invalid
    expect(assistance).to have(1).errors_on(:rating)

    assistance = build(:assistance, rating: 5)
    expect(assistance).to be_invalid
    expect(assistance).to have(1).errors_on(:rating)
  end

end
