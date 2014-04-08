class Authorization < ActiveRecord::Base
  belongs_to :user

  def self.user_from_omniauth(auth)
    authorization = self.find_or_initialize_by(github_uid: auth.uid)
    if auth.provider == "github"
      authorization.organizations_url = auth.extra.raw_info.organizations_url
      authorization.repos_url = auth.extra.raw_info.repos_url
      authorization.token = auth.credentials.token
    end
    
    user = authorization.user || User.new
    user.name = auth.info.name
    if auth.provider == "github"
      user.avatar_url = auth.extra.raw_info.avatar_url
      user.github_url = auth.extra.raw_info.html_url
    end
    user.email ||= auth.info.email
    user.save!

    authorization.user = user
    authorization.save!

    user
  end

  def github_repos
    client = Octokit::Client.new(access_token: self.token)
    client.repositories
  end
end