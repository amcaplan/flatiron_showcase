class Project < ActiveRecord::Base
  has_many :user_projects, dependent: :destroy
  has_many :users, through: :user_projects
  has_many :project_app_types, dependent: :destroy
  has_many :app_types, through: :project_app_types
  has_many :project_images
  validates :github_id, :uniqueness => true
  before_save :remove_empty_strings
   
  def take_app_screenshot!
    self.fix_url_ends

    ws = Webshot::Screenshot.instance
    
    full_app_url = self.live_app_url + "/"
    image_filename = self.image_filename
    
    self.screenshot_path = "assets/project-images/" + image_filename
    save_path = "./public/#{self.screenshot_path}"

    large_image = "#{save_path}_large.png"
    medium_image = "#{save_path}_medium.png"
    small_image = "#{save_path}_small.png"
    thumb_image = "#{save_path}_thumb.png"

    ws.capture full_app_url, large_image, timeout: 1, width: 960, height: 420, quality: 85
    ws.capture full_app_url, medium_image, timeout: 1, width: 583, height: 407, quality: 85
    ws.capture full_app_url, small_image, timeout: 1, width: 290, height: 193, quality: 85
    ws.capture full_lpp_url, thumb_image, timeout: 1, width: 64, height: 64, quality: 85
  end

  def image_filename
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    timestamp + "_" + self.display_name.downcase.gsub(/[\s\?\'\"]/, "_")
  end

  def add_no_screenshot_available_image
    self.screenshot_path = "assets/project-images/not_available"
  end

  def method_missing(meth, *args)
    if meth.to_s.end_with?("_images")
      self.project_images.map do |p_i|
        p_i.image.send(meth.to_s[0..-8]).url
      end 
    else
      super
    end
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

  def images
    ["https://www.google.com/images/srpr/logo11w.png", "https://www.google.com/images/srpr/logo11w.png", "https://www.google.com/images/srpr/logo11w.png"]
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
