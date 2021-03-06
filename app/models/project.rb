class Project < ActiveRecord::Base
  include ActionView::Helpers::DateHelper

  has_many :user_projects, dependent: :destroy
  has_many :users, through: :user_projects
  has_many :project_app_types, dependent: :destroy
  has_many :app_types, through: :project_app_types
  has_many :project_images, dependent: :destroy
  validates :github_id, uniqueness: true
  validates :brief_description, length: { maximum: 40 }
  validates :live_app_url, length: {minimum: 11}
  validates :display_name, length: {minimum: 1}
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
    if self.save # if the user pressed "submit" multiple times, only go through this once!
      full_app_url = self.live_app_url + "/"
      should_be_primary = true unless self.primary_project_image

      begin
        ws = Webshot::Screenshot.instance
        img_path = "#{Rails.root}/tmp/temp-pic.png"
        ws.capture full_app_url, img_path, timeout: 2, width: 1166, height: 814 do |magick|
          magick.combine_options do |c|
            c.background "gray45"
            c.gravity "north"
            c.quality 85
          end
        end

        
        add_image(File.open(img_path), should_be_primary)
        File.delete(img_path)
        if self.primary_image.url.end_with?('not_available.jpg')
          unavailable = self.primary_project_image
          self.set_primary_image_to(self.project_images.last)
          unavailable.remove_image!
          unavailable.destroy
        end
      rescue
        add_image(File.open("app/assets/images/not_available.jpg"), should_be_primary)
      end
    end
  end

  def screenshot_path
    self.primary_image.large.url
  end

  def primary_image
      self.primary_project_image.image if primary_project_image
  end

  def primary_project_image 
    self.project_images.find_by(primary_image: true)
  end

  def set_primary_image_to(project_image)
    begin
      self.primary_project_image.update_attributes(primary_image: false)
    rescue # if no primary image exists
    end
    ProjectImage.find(project_image.id).update_attributes(primary_image: true)
  end

  def screenshots
    self.large_images.sort_by do |image|
      image.id == self.primary_project_image.id ? 0 : 1
    end
  end

  Image = Struct.new(:primary, :url, :id)

  def method_missing(meth, *args)
    if meth.to_s.end_with?("_images") # e.g., .large_images
      self.project_images.map do |p_i|
        Image.new(p_i.primary_image,
          p_i.image.send(meth.to_s[0..-8]).url,
          p_i.id)
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
      last_time = self.client.commits(self.name).first.commit.author.date
      time_ago_in_words(last_time) + " ago"
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

  def visible_users
    self.users.where(display: true)
  end
end
