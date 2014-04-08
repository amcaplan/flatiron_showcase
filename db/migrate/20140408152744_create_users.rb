class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :twitter_handle
      t.string :linkedin_url
      t.string :github_url
      t.string :avatar_url
      t.text :bio
      t.boolean :hireable

      t.timestamps
    end
  end
end
