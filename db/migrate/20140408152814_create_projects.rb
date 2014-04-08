class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :live_app_url
      t.string :screenshot_path
      t.string :brief_description
      t.text :longer_description

      t.timestamps
    end
  end
end
