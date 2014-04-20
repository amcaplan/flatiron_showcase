class Project < ActiveRecord::Base
  has_many :user_projects, dependent: :destroy
  has_many :users, through: :user_projects
  has_many :project_app_types, dependent: :destroy
  has_many :app_types, through: :project_app_types
  has_many :project_images
  validates :github_id, :uniqueness => true
  before_save :remove_empty_strings
   
  def add_image(image, primary = false)
    pi = ProjectImage.new
    pi.project = self
    pi.image = image
    pi.primary_image = true if primary
    pi.save!
  end

  def take_app_screenshot!
    self.fix_url_ends
    self.save
    full_app_url = self.live_app_url + "/"

    begin
      ws = Webshot::Screenshot.instance
      img_path = "public/assets/project-images/#{self.id}.png"
      ws.capture full_app_url, img_path, timeout: 2, width: 1166, height: 814, quality: 85
      add_image(File.open(img_path), true)
      File.delete(img_path)
      if self.primary_image.url.end_with?('not_available.jpg')
        unavailable = self.primary_project_image
        self.set_primary_image_to(self.project_images.last)
        unavailable.remove_image!
        unavailable.destroy
      end
    rescue
      add_image(File.open("app/assets/images/not_available.jpg"), true)
    end
  end

  def screenshot_path
    self.primary_image.large.url
  end

  def primary_image
    self.primary_project_image.image
  end

  def primary_project_image
    self.project_images.find_by(primary_image: true)
  end

  def set_primary_image_to(project_image)
    self.primary_project_image.update_attributes(primary_image: false)
    project_image.primary_image = true
    project_image.save
  end

  def screenshots
    self.large_images
  end

  def method_missing(meth, *args)
    if meth.to_s.end_with?("_images") # e.g., .large_images
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
