class FetchRemoteActivityContent
  include Interactor

  def call
    activity = context.activity
    file_path = activity.content_file_path
    repo_name = activity.content_repository.full_name

    content = github_client.contents(repo_name, path: file_path, accept: 'application/vnd.github.V3.raw')
    activity.instructions = content
    activity.save
  rescue Octokit::NotFound => e
    puts "!! FAILED TO FETCH '#{file_path}' FROM GITHUB !!"
    context.fail! error: e.message
  end

  private

  def github_client
    return @client if @client
    @client = Octokit::Client.new(access_token: ENV['GITHUB_ADMIN_OAUTH_TOKEN'])
    @client.login
    @client
  end

end
