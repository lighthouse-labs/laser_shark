require 'spec_helper'

describe Comment do

  it "has a valid factory" do
    expect(build(:comment)).to be_valid
  end

  it "is invalid without content" do
    comment = build(:comment, content: nil)
    expect(comment).to be_invalid
  end

  it "is invalid without user" do
    comment = build(:comment, user_id: nil)
    expect(comment).to be_invalid
  end

  it "is invalid without commentable" do
    comment = build(:comment, commentable_id: nil)
    expect(comment).to be_invalid
  end

  it "has and knows its user" do
    comment = build(:comment)
    expect(comment.user).should_be_kind_of(User)
  end

  it "has and knows its commentable" do
    comment = build(:comment)
    expect(comment.commentable).should be_true
  end

end
