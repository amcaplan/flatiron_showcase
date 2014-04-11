class RemoveGithubUrlFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :github_url, :string
  end
end
