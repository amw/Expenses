$ ->
  initWheel = ->
    wheel = $ '#colorwheel'

    return unless wheel.size()

    input = $ '#category_color'

    cw = Raphael.colorwheel wheel[0], input.outerWidth()
    cw.input input[0]

    position = input.offset()
    position.top += input.outerHeight() + 2

    input.focus ->
      wheel.show()
      wheel.offset position

    $(input).add(wheel).click (event)->
      event.stopPropagation()

    $('html').click ->
      wheel.hide()

  initWheel()
