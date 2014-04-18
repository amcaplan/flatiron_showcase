class User < ActiveRecord::Base
  has_many :authorizations
  has_many :user_projects, dependent: :destroy
  has_many :projects, through: :user_projects

  def self.create_from_hash(user_info)
    User.create(github_login: user_info.login,
      name: user_info.login,
      avatar_url: user_info.avatar_url)
  end

  def self.visible_users
    self.where(display: true).all
  end

  def github_auth
    @github_auth ||= self.authorizations.where.not(github_uid: nil).first
  end

  def client
    if self.github_auth
      @client ||= self.github_auth.client
    else
      @client = self.projects.map(&:client).first
    end
  end

  def repos
    self.client.repos
  end

  def organizations
    self.client.organizations
  end

  def github_url
    "https://github.com/" + github_login
  end

  def twitter_url
    "http://twitter.com/" + twitter_handle
  end

  Commit = Struct.new(:datetime, :repo, :repo_url, :commit_url)

  def last_commit
    if !@last_commit
      commit_hash = self.client.user_events(self.github_login).select { |event|
        event.type == "PushEvent"
      }.first
      datetime = commit_hash.created_at.strftime("%m/%d/%Y at %I:%M%p")
      repo = commit_hash.repo.name.gsub(/.+\//,'')
      repo_url = "https://github.com/" + commit_hash.repo.name
      commit_url = "#{repo_url}/commit/#{commit_hash.payload.commits.last.sha}"
    end
    @last_commit ||= Commit.new(datetime, repo, repo_url, commit_url)
  end
end