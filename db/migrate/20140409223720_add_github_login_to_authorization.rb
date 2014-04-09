class AddGithubLoginToAuthorization < ActiveRecord::Migration
  def change
    add_column :authorizations, :github_login, :string
  end
end
