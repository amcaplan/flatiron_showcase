class Authorization < ActiveRecord::Base
  belongs_to :user

  def self.user_from_omniauth(auth)
    authorization = self.find_or_initialize_by(github_uid: auth.uid)
    if auth.provider == "github"
      authorization.token = auth.credentials.token
      authorization.github_login = auth.login

      # Verify that the user is in the flatiron-school-students organization
      return false if !authorization.organizations.map(&:id).include?(6207995)
    end
    
    user = authorization.user || User.new
    user.name ||= auth.info.name

    if auth.provider == "github"
      user.name ||= auth.extra.raw_info.login
      user.github_login = auth.extra.raw_info.login
      user.avatar_url = auth.extra.raw_info.avatar_url
    end
    user.email ||= auth.info.email
    user.save!

    authorization.user = user
    authorization.save!

    user
  end

  def client
    @client ||= Octokit::Client.new(access_token: self.token)
  end

  def repos
    client.repositories
  end

  def organizations
    client.organizations
  end
end