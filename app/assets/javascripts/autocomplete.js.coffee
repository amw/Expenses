$ ->
  categoryByAttr = (attr, value) ->
    for id, category of all_categories
      return category if category[attr] == value

  categoryColor = (label) ->
    category = categoryByAttr 'label', label
    category && category.color || 'black'

  searchCategories = (request, callback) ->
    result = []
    re = new RegExp( '^' + request.term + '.*$', 'i' )
    for id, category of all_categories
      result.push category if re.test category.label

    callback result

  autocompleteopen = (e, ui) ->
    $('.ui-autocomplete .ui-menu-item').each ->
      label = $(this).find('a').html()
      $(this).css 'background-color': categoryColor(label)

  $('#transaction_category_name').autocomplete
    delay: 0,
    source: searchCategories,
    open: autocompleteopen
