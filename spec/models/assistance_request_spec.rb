require 'spec_helper'

describe AssistanceRequest do

  it 'has a valid factory' do
    expect(build(:assistance_request)).to be_valid
  end

  it 'should not save if the requestor has an open assistance request' do
    ar = create(:assistance_request)
    new_ar = build(:assistance_request, requestor: ar.requestor)
    expect { new_ar.save! }.to raise_error
    expect(new_ar.errors[:base]).to include('Limit one open/in progress request per user')
  end

  it 'should save if previous assistance requests have been cancelled' do
    ar = create(:assistance_request, canceled_at: Date.current )
    new_ar = build(:assistance_request, requestor: ar.requestor)
    expect { new_ar.save! }.to_not raise_error
  end

  it 'should not save if the requestor has an in progress assistance request' do
    ar = create(:assistance_request, assistance: create(:assistance))
    new_ar = build(:assistance_request, requestor: ar.requestor)
    expect { new_ar.save! }.to raise_error
    expect(new_ar.errors[:base]).to include('Limit one open/in progress request per user')
  end

  it 'should save if previous assistance requests have been completed' do
    ar = create(:assistance_request, assistance: create(:assistance, end_at: Date.current) )
    new_ar = build(:assistance_request, requestor: ar.requestor)
    expect { new_ar.save! }.to_not raise_error
  end

end
