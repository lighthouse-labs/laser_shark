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

  describe '#end' do
    before :each do
      @assistance = create(:assistance, assistance_request: create(:code_review_request))
    end

    it 'should increase the assistee\'s code review percent if they got a low rating' do
      code_review_percent = @assistance.assistee.code_review_percent
      rating = Assistance::RATING_BASELINE - 1
      @assistance.end('test', rating)
      expect(@assistance.assistee.code_review_percent).to eq(code_review_percent + (Assistance::RATING_BASELINE - rating))
    end

    it 'should decrease the assistee\'s code review percent if they got a hight rating' do
      code_review_percent = @assistance.assistee.code_review_percent
      rating = Assistance::RATING_BASELINE + 1
      @assistance.end('test', rating)
      expect(@assistance.assistee.code_review_percent).to eq(code_review_percent + (Assistance::RATING_BASELINE - rating))
    end

    it 'should not change the assistee\'s code review percent their code review percent is nil' do
      code_review_percent = @assistance.assistee.code_review_percent
      rating = Assistance::RATING_BASELINE
      @assistance.end('test', rating)
      expect(@assistance.assistee.code_review_percent).to eq(code_review_percent)
    end

    it 'should not change the assistee\'s code review percent their code review percent is nil' do
      @assistance.assistee.update_attributes(code_review_percent: nil)
      code_review_percent = @assistance.assistee.code_review_percent
      rating = Assistance::RATING_BASELINE + 1
      @assistance.end('test', rating)
      expect(@assistance.assistee.code_review_percent).to eq(code_review_percent)
    end
  end
end
