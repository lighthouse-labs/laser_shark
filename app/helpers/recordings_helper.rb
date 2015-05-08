module RecordingsHelper
  def recording_title(recording)
    (recording.nil? || recording.title.nil? || recording.title.empty?) ? 'Untitled' : recording.title
  end
end
