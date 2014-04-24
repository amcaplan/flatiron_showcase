class GitHubQuerier
  attr_accessor :user
  attr_accessor :client

  def initialize(user)
    @user = user
    @client = user.client
  end

  def repos
    user_repos = self.client.repos
    results = self.client.last_response
    next_page = ""
    # This loop is convoluted because when the list is done, Octokit still
    # gives a "next" reference to the currently loaded set of results. Boo.
    until !results.rels[:next] || next_page == results.rels[:next]
      next_page = results.rels[:next]
      user_repos += next_page.get.data
      results = self.client.last_response
    end
    user_repos
  end

  Commit = Struct.new(:datetime, :repo, :repo_url, :commit_url)

  def last_commit
    begin
      commit_hash = self.client.user_events(user.github_login).select { |event|
        event.type == "PushEvent"
      }.first
      datetime = commit_hash.created_at.strftime("%m/%d/%Y at %I:%M%p")
      repo = commit_hash.repo.name.gsub(/.+\//,'')
      repo_url = "https://github.com/" + commit_hash.repo.name
      commit_url = "#{repo_url}/commit/#{commit_hash.payload.commits.last.sha}"
      Commit.new(datetime, repo, repo_url, commit_url)
    rescue
    end
  end
end