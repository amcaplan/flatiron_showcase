class AddOwnerToUserProject < ActiveRecord::Migration
  def change
    add_column :user_projects, :owner, :boolean
  end
end
