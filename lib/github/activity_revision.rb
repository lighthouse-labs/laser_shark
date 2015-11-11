class ActivityRevision

  def initialize(activity)
    @activity = activity
  end

  # Designed to fail silently, but notify error system (Raven / SentryApp)
  def commit
    return nil unless client
    if @activity.revisions_gistid?
      update
    else
      create
    end
  rescue Octokit::Error => e
    Raven.capture_exception(e)
    nil
  end

  private

  def create
    g = client.create_gist(gist_params)
    # Don't want to trigger validations nor update updated_at
    Activity.where(id: @activity.id).update_all(revisions_gistid: g[:id])
    @activity.revisions_gistid = g[:id]
    g
  end

  def update
    g = client.edit_gist(@activity.revisions_gistid, gist_params)
  end

  def client
    return @client if @client
    return nil unless ENV['GIST_TOKEN'].present?
    @client = Octokit::Client.new(access_token: ENV['GIST_TOKEN'])
    @client.login
    @client
  end

  def gist_params
    {
      'public' => false,
      'description' => "#{@activity.day} - #{@activity.name} (#{@activity.type})",
      'files' => {
        'instructions.md' => {
          content: "\#Instructions\n#{@activity.instructions}"
        },
        'notes.md' => {
          content: "\#Teacher Notes\n#{@activity.teacher_notes}"
        },
        '_data.yml' => {
          content: @activity.attributes.except("teacher_notes", "instructions", "created_at", "updated_at").to_yaml
        }
      }
    }
  end

end