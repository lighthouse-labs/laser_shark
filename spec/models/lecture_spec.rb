require 'spec_helper'

describe Lecture do

  it "has a valid factory" do
    expect(build(:lecture)).to be_valid
  end

  it "should update the teacher notes" do
    lecture = create(:lecture, teacher_notes_gist_url: "http://gist.github.com/fakej39f3")
    ActivityGist.any_instance.stub(:initialize)
    ActivityGist.any_instance.stub(:activity_content).and_return("Here are the instructions")
    lecture.update_teacher_notes_from_gist
    expect(lecture.teacher_notes).to eq("Here are the instructions")
  end

  it "should update the teacher notes when the lecture is created" do
    lecture = build(:lecture, teacher_notes_gist_url: "http://gist.github.com/fakej39f3")
    lecture.should_receive(:update_teacher_notes_from_gist)
    lecture.save!
  end

end
