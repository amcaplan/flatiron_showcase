class User < ActiveRecord::Base
  has_many :authorizations
  has_many :user_projects, dependent: :destroy
  has_many :projects, through: :user_projects
  before_save :remove_twitter_at, :add_linkedin_http

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
    GitHubQuerier.new(self).repos
  end

  def last_commit
    @last_commit ||= GitHubQuerier.new(self).last_commit
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

  def remove_twitter_at
    if self.twitter_handle && self.twitter_handle.start_with?("@")
      self.twitter_handle = self.twitter_handle[1..-1]
    end
  end

  def add_linkedin_http
    if self.linkedin_url && !self.linkedin_url.start_with?("http://") &&
      !self.linkedin_url.start_with?("https://")
      self.linkedin_url = "http://" + self.linkedin_url
    end
  end
end