class Project < ActiveRecord::Base
  has_many :user_projects, dependent: :destroy
  has_many :users, through: :user_projects
  has_many :project_app_types, dependent: :destroy
  has_many :app_types, through: :project_app_types
  validates :github_id, :uniqueness => true
  before_save :remove_empty_strings
   
  def take_app_screenshot!
    self.fix_url_ends

    ws = Webshot::Screenshot.instance
     
    full_live_app_url = self.live_app_url + "/"
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    image_filename = timestamp + "_" + self.display_name.downcase.gsub(/[\s\?\'\"]/, "_")
    self.screenshot_path = "assets/project-images/" + image_filename
    saving_dir = "./public/assets/project-images/"

    large_image = image_filename + "_large.png"
    medium_image = image_filename + "_medium.png"
    small_image = image_filename + "_small.png"
    thumb_image = image_filename + "_thumb.png"

    ws.capture full_live_app_url, saving_dir + large_image, timeout: 1, width: 960, height: 420, quality: 85
    ws.capture full_live_app_url, saving_dir + medium_image, timeout: 1, width: 583, height: 407, quality: 85
    ws.capture full_live_app_url, saving_dir + small_image, timeout: 1, width: 290, height: 193, quality: 85
    ws.capture full_live_app_url, saving_dir + thumb_image, timeout: 1, width: 64, height: 64, quality: 85
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

  def next_project
    Project.where("id > ?", id).order(id: :asc).first
  end

  def previous_project
    Project.where("id < ?", id).order(id: :asc).last
  end

  def client
    users.map(&:github_auth).compact.first.client
  end

  def last_commit
    begin
      self.client.commits(self.name).first.commit.author.date.
        strftime("%m/%d/%Y at %I:%M%p")
    rescue
      "No Commits Yet"
    end
  end

  def github_url
    "github.com/" + self.name
  end

  def fix_url_ends
    if !self.live_app_url.start_with?("http://") && !self.live_app_url.start_with?("https://")
      self.live_app_url = "http://#{self.live_app_url}"
    end
    self.live_app_url.chop! if self.live_app_url.end_with?("/")
  end

  def brief_description
    super || "[DESCRIPTION PENDING]"
  end

  def remove_empty_strings
    [:brief_description, :longer_description, :technologies].each do |attr|
      self.send("#{attr}=", nil) if self.send(attr) == ""
    end
  end
end
