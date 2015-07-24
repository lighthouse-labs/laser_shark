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
    ar = create(:canceled_assistance_request)
    new_ar = build(:assistance_request, requestor: ar.requestor)
    expect { new_ar.save! }.to_not raise_error
  end

  it 'should save if the assistance request reason is longer than 255 characters' do
    ar = build(:assistance_request, reason: (0...300).map { (65 + rand(26)).chr }.join)
    expect { ar.save! }.to_not raise_error
  end

  it 'should not save if the requestor has an in progress assistance request' do
    ar = create(:in_progress_assistance_request)
    new_ar = build(:assistance_request, requestor: ar.requestor)
    expect { new_ar.save! }.to raise_error
    expect(new_ar.errors[:base]).to include('Limit one open/in progress request per user')
  end

  it 'should save if previous assistance requests have been completed' do
    ar = create(:completed_assistance_request)
    new_ar = build(:assistance_request, requestor: ar.requestor)
    expect { new_ar.save! }.to_not raise_error
  end

  it 'should be able to be created while a code review request is open or in progress' do
    crr = create(:code_review_request)
    expect { create(:assistance_request, requestor: crr.requestor) }.to_not raise_error
  end

  describe '#open?' do
    it 'returns true if the request is not cancelled and does not have an assistance' do
      expect(create(:assistance_request).open?).to be_true
    end
    it 'returns false if the request is canceled' do
      expect(create(:canceled_assistance_request).open?).to be_false
    end
    it 'returns false if the request is in progress' do
      expect(create(:in_progress_assistance_request).open?).to be_false
    end
    it 'returns false if the request is completed' do
      expect(create(:completed_assistance_request).open?).to be_false
    end
  end

  describe '#in_progress?' do
    it 'returns true if the request is not cancelled and has an assistance that has not ended' do
      expect(create(:in_progress_assistance_request).in_progress?).to be_true
    end
    it 'returns false if the request is canceled' do
      expect(create(:canceled_assistance_request).in_progress?).to be_false
    end
    it 'returns false if the request is open' do
      expect(create(:assistance_request).in_progress?).to be_false
    end
    it 'returns false if the request has an assistance that has ended' do
      expect(create(:completed_assistance_request).in_progress?).to be_false
    end
  end

  describe '#position_in_queue' do
    it 'returns a 1 indexed number representing a request\'s position in the request queue' do
      ar1 = create(:assistance_request)
      expect(ar1.position_in_queue).to eq(1)
      ar2 = create(:assistance_request)
      expect(ar1.position_in_queue).to eq(1)
      expect(ar2.position_in_queue).to eq(2)
      ar3 = create(:assistance_request)
      expect(ar1.position_in_queue).to eq(1)
      expect(ar2.position_in_queue).to eq(2)
      expect(ar3.position_in_queue).to eq(3)
      ar1.update_attributes(assistance: create(:assistance))
      expect(ar1.position_in_queue).to be_nil
      expect(ar2.position_in_queue).to eq(1)
      expect(ar3.position_in_queue).to eq(2)
      ar3.update_attributes(assistance: create(:assistance))
      expect(ar2.position_in_queue).to eq(1)
      expect(ar3.position_in_queue).to be_nil
    end
    it 'returns nil for canceled requests' do
      expect(create(:canceled_assistance_request).position_in_queue).to be_nil
    end
    it 'returns nil for in progress requests' do
      expect(create(:in_progress_assistance_request).position_in_queue).to be_nil
    end
    it 'returns nil for completed requests' do
      expect(create(:completed_assistance_request).position_in_queue).to be_nil
    end
  end

  describe '.in_progress_requests' do
    it 'includes requests that are not canceled and have assistances that have not ended' do
      ar = create(:in_progress_assistance_request)
      expect(AssistanceRequest.in_progress_requests).to include(ar)
    end
    it 'does not include requests that are canceled' do
      ar = create(:canceled_assistance_request)
      expect(AssistanceRequest.in_progress_requests).to_not include(ar)
    end
    it 'does not include requests that have assistances that have ended' do
      ar = create(:completed_assistance_request)
      expect(AssistanceRequest.in_progress_requests).to_not include(ar)
    end
    it 'does not include requests that do not have assistances' do
      ar = create(:assistance_request)
      expect(AssistanceRequest.in_progress_requests).to_not include(ar)
    end
  end

end
