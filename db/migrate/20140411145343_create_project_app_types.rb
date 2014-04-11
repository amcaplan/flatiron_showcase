class CreateProjectAppTypes < ActiveRecord::Migration
  def change
    create_table :project_app_types do |t|
      t.references :project, index: true
      t.references :app_type, index: true

      t.timestamps
    end
  end
end
