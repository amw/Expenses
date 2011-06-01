#= require jquery
#= require jquery_ujs
#= require jquery-ui
#= require raphael.min
#= require colorwheel
#= require g.raphael
#= require g.line
#= require g.pie
#= require_self
#= require_tree .

$ ->
  $.datepicker.setDefaults dateFormat: 'yy-mm-dd'
  $('.button').button()
  $('.buttonset').buttonset()
  $('#transaction_date').datepicker()

  setTimeout ->
    $('#notice').hide("fade", {}, 1000)
  , 1000

  Raphael.fn.g.txtattr =
    'font-size': '14px'
    'font-family': '"Helvetica Neue", Arial, Helvetica, sans-serif'
    'font-weight': 100
