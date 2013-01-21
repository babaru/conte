class ConteBreadcrumbsRenderer < SimpleNavigation::Renderer::Base
  def render(item_container)
    a_tag(item_container).join.html_safe
  end

  protected

  def a_tag(item_container)
    item_container.items.inject([]) do |list, item|
      if item.selected?
        list << content_tag(:li, tag_for(item)) if item.selected?
        if include_sub_navigation?(item)
          list.concat a_tags(item.sub_navigation)
        end
      end
      list
    end
  end
end