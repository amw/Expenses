function categoryColor(label) {
  for (i in categories) {
    if (categories[i]['label'] == label) {
      return categories[i]['color'];
    }
  }
  return 'black';
}

function autocompleteopen(e, ui) {
  $('.ui-autocomplete .ui-menu-item').each(function() {
    var label = $(this).find('a').html();
    $(this).css('background-color', categoryColor(label));
  });
}

function initWheel(wheel) {
  var input = $('#category_color');

  var cw = Raphael.colorwheel(wheel[0],input.outerWidth());
  cw.input(input[0]);

  var position = input.offset();
  position.top += input.outerHeight() + 2;

  input.focus(function() {
    wheel.show();
    wheel.offset(position);
  });

  $(input).add(wheel).click(function(event) {
    event.stopPropagation();
  });

  $('html').click(function() {
    wheel.hide();
  });
}

$(function() {
  $.datepicker.setDefaults({ dateFormat: 'yy-mm-dd' });
  $('.button').button();
  $('.buttonset').buttonset();
  $('#transaction_date').datepicker();
  $('#transaction_category_name').autocomplete({
    delay: 0,
    source: categories,
    open: autocompleteopen
  });

  setTimeout(function() {
    $('#notice').hide("fade", {}, 1000);
  }, 1000);

  var wheel = $('#colorwheel');
  if (wheel.length) {
    initWheel(wheel);
  }
});
