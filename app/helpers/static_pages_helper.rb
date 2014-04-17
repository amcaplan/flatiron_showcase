module StaticPagesHelper
  def split_to_length(str, length)
    str.scan(/\S.{1,#{length}}(?!\S)/)
  end
end
