class User < ActiveRecord::Base
  has_many :authorizations
  has_many :user_projects
  has_many :projects, through: :user_projects

  def github_auth
    @github_auth = self.authorizations.where.not(github_uid: nil).first
  end

  def repos
    self.github_auth.repos
  end

  def organizations
    self.github_auth.organizations
  end
end