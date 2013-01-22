class NavigationRenderer < SimpleNavigation::Renderer::Base
  def render(item_container)
    list_content = item_container.items.inject([]) do |list, item|
      li_content = []
      li_content << tag_for(item)
      if include_sub_navigation?(item)
        li_content << render_sub_navigation_for(item)
      end
      list << content_tag(:div, li_content.join, class: 'accordion-group')
    end.join
    if skip_if_empty? && item_container.empty?
      ''
    else  
      content_tag :div, list_content, {:class => 'accordion', "id" => 'navigation'}
    end
  end

  protected

  def tag_for(item)
    item_content = nil
    options = link_options_for(item)
    if suppress_link?(item)
      content = []
      content << item.name
      content << content_tag(:b, nil, class: 'caret')
      if options[:class] && options[:class].include?('active')
        options[:class] = [options[:class], 'accordion-toggle in'].flatten.compact.join(' ')
      else
        options[:class] = [options[:class], 'accordion-toggle collapsed'].flatten.compact.join(' ')
      end
      options = options.merge('data-toggle' => "collapse", 'data-parent' => "#navigation")
      item_content = link_to(content.join(' '), "#collapse_#{item.key}", options)
    else
      options[:class] = [options[:class], 'accordion-toggle'].flatten.compact.join(' ')
      item_content = link_to(item.name, item.url, options)
    end
    content_tag :div, item_content, class: 'accordion-heading'
  end

  def render_sub_navigation_for(item)
    options = link_options_for(item)
    sub_list_content = item.sub_navigation.items.inject([]) do |list, sub_item|
      li_content = link_to(sub_item.name, sub_item.url, link_options_for(sub_item))
      list << content_tag(:li, li_content)
    end.join
    sub_list = content_tag(:ul, sub_list_content)
    inner_container = content_tag(:div, sub_list, class: 'accordion-inner')
    if options[:class] && options[:class].include?('active')
      content_tag(:div, inner_container, {:class => 'accordion-body in collapse', 'id' => "collapse_#{item.key}"})
    else
      content_tag(:div, inner_container, {:class => 'accordion-body collapse', 'id' => "collapse_#{item.key}"})
    end
  end
end