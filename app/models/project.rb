class Project < ActiveRecord::Base
  has_many :user_projects
  has_many :users, through: :user_projects

  def self.take_app_screenshot!(project)
    ws = Webshot::Screenshot.instance
     
    live_app_url = "http://" + project.live_app_url + "/"
    saving_dir = "public/assets/project-images/"
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")

    if project.live_app_url
      large_image = timestamp + "_" + project.display_name.downcase.tr(" ", "_") + "_large.png"
      medium_image = timestamp + "_" + project.display_name.downcase.tr(" ", "_") + "_medium.png"
      small_image = timestamp + "_" + project.display_name.downcase.tr(" ", "_") + "_small.png"
      thumb_image = timestamp + "_" + project.display_name.downcase.tr(" ", "_") + "_thumb.png"

      
      ws.capture live_app_url, saving_dir + large_image, width: 960, height: 420, quality: 85
      ws.capture live_app_url, saving_dir + medium_image, width: 583, height: 407, quality: 85
      ws.capture live_app_url, saving_dir + small_image, width: 290, height: 193, quality: 85
      ws.capture live_app_url, saving_dir + thumb_image, width: 64, height: 64, quality: 85
     
      screenshot_path = saving_dir + timestamp + "_" + project.display_name.downcase.tr(" ", "_")
    end
  end
end
