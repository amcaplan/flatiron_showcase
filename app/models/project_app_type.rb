class ProjectAppType < ActiveRecord::Base
  belongs_to :project
  belongs_to :app_type
end
