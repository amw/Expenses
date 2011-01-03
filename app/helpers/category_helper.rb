module CategoryHelper
  def category_label(category)
    category_style(category, category.name)
  end

  def category_style(category, text)
    ('<span class="category category-style ui-corner-all cat-' + category.id.to_s + '" ' +
      'style="background-color: ' + category.color + ';">' + text.to_s +
    '</span>').html_safe
  end
end
