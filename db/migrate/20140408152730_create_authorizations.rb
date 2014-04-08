class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.string :github_uid
      t.string :repos_url
      t.string :organizations_url
      t.references :user, index: true

      t.timestamps
    end
  end
end
