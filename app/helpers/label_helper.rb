# encoding: utf-8

module LabelHelper
  def category_label category, klass = ''
    ("<span class='category category-style ui-corner-all " +
        "cat-#{category.id.to_s} #{klass}' " +
      "style='background-color: #{category.color};' " +
      "data-category-id='#{category.id}'>#{category.name}</span>").html_safe
  end

  def category_link(category)
    ('<a href="' + url_for(category) +
      '" class="category category-style ui-corner-all ' +
      'cat-' + category.id.to_s + '" ' +
      'style="background-color: ' + category.color + ';">' +
      category.name + '</a>').html_safe
  end

  def value_label(transaction)
    if transaction.kind_of? Transaction
      value_style(transaction.type, transaction.abs_value)
    else
      if transaction > 0
        value_style(Transaction::Income, transaction)
      else
        value_style(Transaction::Expense, transaction.abs)
      end
    end
  end

  def value_style(type, value)
    ('<span class="' + type + ' value-style ui-corner-all">' +
     currency(value) + '</span>').html_safe
  end

  def currency(value)
    number_to_currency value, :unit => "zł", :format => '%n%u', :precision => 0
  end
end
