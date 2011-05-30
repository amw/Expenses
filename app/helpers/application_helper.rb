module ApplicationHelper
  def navigation_button *args
    options = args.extract_options!

    text = options[:text] || args.shift.to_s.capitalize
    path = options[:path] || args.shift

    if options[:selected].nil?
      selected = request.path.starts_with? path
    else
      selected = options[:selected]
    end

    classes = options[:class] || ''
    classes += ' ui-button ui-widget ui-state-default ui-button-text-only'
    classes += ' ui-state-active' if selected

    link_to \
      "<span class='ui-button-text'>#{text}</span>".html_safe,
      path, class: classes
  end
end
