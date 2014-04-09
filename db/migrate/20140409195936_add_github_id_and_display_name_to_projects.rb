class AddGithubIdAndDisplayNameToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :github_id, :string
    add_column :projects, :display_name, :string
  end
end
