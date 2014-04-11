class AppType < ActiveRecord::Base
  has_many :project_app_types, dependent: :destroy
  has_many :projects, through: :project_app_types

  def slug
    self.name.tr(" ", "-")
  end
end
