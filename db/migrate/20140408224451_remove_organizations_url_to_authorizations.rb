class RemoveOrganizationsUrlToAuthorizations < ActiveRecord::Migration
  def change
    remove_column :authorizations, :organizations_url, :string
  end
end
