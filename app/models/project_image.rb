class ProjectImage < ActiveRecord::Base
  belongs_to :project
  mount_uploader :image, ScreenshotUploader
  before_destroy :remove_images

  def remove_images
    self.remove_image!
  end
end
