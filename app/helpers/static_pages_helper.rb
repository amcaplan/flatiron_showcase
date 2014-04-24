module StaticPagesHelper
  def add_newlines(str)
    safe_join(str.split(/\r\n\r/), tag(:br))
  end

  def split_string(str, length)
    lines = str.scan(/\S.{1,#{length}}(?!\S)/).map {|line|
      add_newlines(line)
    }
    if lines[9]
      until lines[9].end_with?("...")
        lines[9] << "."
      end
      lines = lines[0, 10]
    end
    safe_join lines, tag(:br)
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
