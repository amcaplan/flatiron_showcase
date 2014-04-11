class RemoveOwnerFromUserProjects < ActiveRecord::Migration
  def change
    remove_column :user_projects, :owner, :string
  end
end
