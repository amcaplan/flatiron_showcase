class AddDisplayToUsers < ActiveRecord::Migration
  def change
    add_column :users, :display, :boolean
  end
end
