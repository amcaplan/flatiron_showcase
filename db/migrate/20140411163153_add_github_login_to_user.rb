class AddGithubLoginToUser < ActiveRecord::Migration
  def change
    add_column :users, :github_login, :string
  end
end
