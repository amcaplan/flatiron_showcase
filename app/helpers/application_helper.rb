module ApplicationHelper
  def new_tab_link(*args, &block)
    link_to(*args, target: '_blank', &block)
  end
end
