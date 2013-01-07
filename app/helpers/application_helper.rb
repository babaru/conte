module ApplicationHelper
  def render_icon_and_text_content(icon_name, text)
    content = []
    content << content_tag(:i, nil, class: icon_name)
    content << content_tag(:span, text)
    content.join(" ").html_safe
  end

  def render_icon_content(icon_name)
    content_tag(:i, nil, class: icon_name)
  end
end
