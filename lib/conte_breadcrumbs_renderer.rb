class ConteBreadcrumbsRenderer < SimpleNavigation::Renderer::Breadcrumbs
  def render(item_container)
    contents = a_tags.inject([]) do |list, item|
      list << content_tag(:li, item.html_safe)
      list
    end
    contents.join('').html_safe
  end
end