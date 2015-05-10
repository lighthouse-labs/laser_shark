require 'spec_helper'

describe ActivitySubmission do
  it 'has a valid factory' do
    expect(build(:activity_submission)).to be_valid
    expect(build(:activity_submission_with_link)).to be_valid
  end

  describe '#save' do
    before :each do
      @very_high_probability = 2 ** (32 - 1) - 1
    end

    it 'should trigger a code review if the activity and student percents are both 100' do
      as = create(
        :activity_submission_with_link,
        user: create(:student, code_review_percent: 100),
        activity: create(:activity, code_review_percent: 100)
      )
      expect(as.code_review_request).to be_a(CodeReviewRequest)
    end

    it 'should not trigger a code review if the activity percent is 0' do
      as = create(
        :activity_submission_with_link,
        user: create(:student, code_review_percent: @very_high_probability),
        activity: create(:activity, code_review_percent: 0)
      )
      expect(as.code_review_request).to be_nil
    end

    it 'should not trigger a code review if the student percent is 0' do
      as = create(
        :activity_submission_with_link,
        user: create(:student, code_review_percent: 0),
        activity: create(:activity, code_review_percent: @very_high_probability)
      )
      expect(as.code_review_request).to be_nil
    end

    it 'should not trigger a code review if the activity percent is nil' do
      as = create(
        :activity_submission_with_link,
        user: create(:student, code_review_percent: @very_high_probability),
        activity: create(:activity, code_review_percent: nil)
      )
      expect(as.code_review_request).to be_nil
    end

    it 'should not trigger a code review if the student percent is nil' do
      as = create(
        :activity_submission_with_link,
        user: create(:student, code_review_percent: nil),
        activity: create(:activity, code_review_percent: @very_high_probability)
      )
      expect(as.code_review_request).to be_nil
    end
  end
end
