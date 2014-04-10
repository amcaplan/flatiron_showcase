class User < ActiveRecord::Base
  has_many :authorizations
  has_many :user_projects
  has_many :projects, through: :user_projects

  before_save :remove_http

  def github_auth
    @github_auth = self.authorizations.where.not(github_uid: nil).first
  end

  def repos
    self.github_auth.repos
  end

  def organizations
    self.github_auth.organizations
  end

  def remove_http
    if live_app_url.start_with?("http://")
      live_app_url = live_app_url[7..-1]
    end
  end
end