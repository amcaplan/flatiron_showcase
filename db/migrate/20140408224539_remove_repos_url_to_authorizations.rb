class RemoveReposUrlToAuthorizations < ActiveRecord::Migration
  def change
    remove_column :authorizations, :repos_url, :string
  end
end
