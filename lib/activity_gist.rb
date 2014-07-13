class ActivityGist

  attr_accessor :url

  DEFAULT_FILE_NAME = 'README.md'

  def initialize(url)
    @url = url
    client = Github.new
    @gist = client.gists.get(gist_id)
  end

  # Gists have instructions in markdown format
  # Typically these are stored in README.md
  # If there is no README.md, returns the content of the first 
  # markdown file
  def activity_content
    readme = @gist.files[DEFAULT_FILE_NAME]
    readme ||= files_with_extension('md').try(:first)
    readme.try(:content)
  end

  def files
    @gist.files
  end

  def files_with_extension(extension)
    return if !extension.present?
    results = files.select {|file_name, file| file_name.ends_with?(".#{extension}")}
    results.values
  end

  private
  def gist_id
    @url.split('/').last
  end
end
