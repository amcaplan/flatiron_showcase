class AddTechnologiesToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :technologies, :string
  end
end
