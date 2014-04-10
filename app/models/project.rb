class Project < ActiveRecord::Base
  has_many :user_projects
  has_many :users, through: :user_projects
  validates :github_id, :uniqueness => true 
   
  def take_app_screenshot!
    ws = Webshot::Screenshot.instance
     
    live_app_url = "http://" + self.live_app_url + "/"
    saving_dir = "public/assets/project-images/"
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    image_filename = timestamp + "_" + self.display_name.downcase.tr(" ", "_")

    if self.live_app_url
      large_image = image_filename + "_large.png"
      medium_image = image_filename + "_medium.png"
      small_image = image_filename + "_small.png"
      thumb_image = image_filename + "_thumb.png"

      ws.capture live_app_url, saving_dir + large_image, width: 960, height: 420, quality: 85
      ws.capture live_app_url, saving_dir + medium_image, width: 583, height: 407, quality: 85
      ws.capture live_app_url, saving_dir + small_image, width: 290, height: 193, quality: 85
      ws.capture live_app_url, saving_dir + thumb_image, width: 64, height: 64, quality: 85
     
      self.screenshot_path = saving_dir + image_filename
    end
  end

  def add_no_screenshot_available_image
    # TODO Add this method
  end

  def screenshots
    [self.screenshot_path, self.screenshot_path]
  end

  def first?
    @first ||= self == Project.first
  end

  def last?
    @last ||= self == Project.last
  end

  def tags #TODO make skill tags!
    %w{artwork nature}
    #%w{HTML5 CSS3 JavaScript jQuery Twitter\ Bootstrap}
  end

  def other_collaborators(user)
    [user]
    # FIXME will be users.where.not(id: user.id)
  end

  def next_project
    Project.where("id > ?", id).order(id: :asc).first
  end

  def previous_project
    Project.where("id < ?", id).order(id: :asc).last
  end
end
