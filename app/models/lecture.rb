class Lecture < Activity
  after_create :update_teacher_notes_from_gist

  def update_teacher_notes_from_gist
    return if !self.teacher_notes_gist_url?
    gist = ActivityGist.new(self.teacher_notes_gist_url)
    self.teacher_notes = gist.activity_content
    self.save
  end

end
