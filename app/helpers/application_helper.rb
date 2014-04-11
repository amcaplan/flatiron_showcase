module ApplicationHelper
  def new_tab_link(*args)
    link_to(*args, target: '_blank')
  end
end
