require 'spec_helper'

describe CodeReviewRequest do

  it 'has a valid factory' do
    expect(build(:code_review_request)).to be_valid
  end

  it 'should be able to be created while the requestor has an open or in progress assistance request' do
    ar = create(:assistance_request)
    expect { create(:code_review_request, requestor: ar.requestor) }.to_not raise_error
  end

end
