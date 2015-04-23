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

  describe '.currently_active' do
    it 'should include both assistance requests and code review requests' do
      a = create(:assistance)
      crra = create(:assistance, assistance_request: create(:code_review_request))
      expect(Assistance.currently_active).to include(a, crra)
    end
    it 'should not include assistances whose assistance requests have been canceled' do
      a = create(:assistance, assistance_request: create(:canceled_assistance_request))
      expect(Assistance.currently_active).to_not include(a)
    end
  end

end
