json.array!(@users) do |user|
  json.extract! user, :id, :name, :email, :twitter_handle, :linkedin_url, :github_url, :avatar_url, :bio, :hireable
  json.url user_url(user, format: :json)
end
