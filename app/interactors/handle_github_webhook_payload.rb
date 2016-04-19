class HandleGithubWebhookPayload
  include Interactor

  def call
    payload = JSON.parse(context.payload)
    
    owner, repo = payload['repository']['full_name'].split('/')
    @repo = ContentRepository.where(github_username: owner, github_repo: repo).first

    commits = payload['commits']

    return true unless commits.present?

    commits.each do |commit|
      process_commit(commit)
    end
  end

  private

  def process_commit(commit)
    return unless commit['modified'].present?
    commit['modified'].each do |file_path|
      process_file(file_path)
    end
  end

  def process_file(file_path)
    if activity = @repo.activities.find_by(remote_content: true, content_file_path: file_path)
      response = FetchRemoteActivityContent.call(activity: activity)
      # don't crap out if activity fails, but log it
      puts response.error unless response.success?
    end
  end

end
