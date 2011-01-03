# encoding: utf-8

module LabelHelper
  def category_label(category)
    category_style(category, category.name, 'category')
  end

  def category_style(category, text, klass = '')
    klass += ' ' if klass.present?
    ('<span class="' + klass + 'category-style ui-corner-all ' + 
        'cat-' + category.id.to_s + '" ' +
      'style="background-color: ' + category.color + ';">' +
      text + '</span>').html_safe
  end

  def value_label(transaction)
    value = number_to_currency transaction.value, :unit => "zł",
              :format => '%n%u'
    ('<span class="' + transaction.type + ' value-style ui-corner-all">' +
     value + '</span>').html_safe
  end
end
