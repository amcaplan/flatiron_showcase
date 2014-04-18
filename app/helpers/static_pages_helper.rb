module StaticPagesHelper
  def split_to_length(str, length)
    str.scan(/\S.{1,#{length}}(?!\S)/)
  end

  def image_size(project)
    return @image_size if @last_project == project
    @last_project = project
    tens_of_projects = project.users.size / 10
    if tens_of_projects == 0
      @image_size = 100
    else
      @image_size = 100 / (Math.sqrt(2) * Math.log(tens_of_projects, 2).to_i)
    end
  end
end
