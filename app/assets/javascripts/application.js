//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require raphael.min
//= require colorwheel
//= require g.raphael.min
//= require g.pie
//= require_self
//= require_tree .


function categoryColor(label) {
  for (i in all_categories) {
    if (all_categories[i]['label'] == label) {
      return all_categories[i]['color'];
    }
  }
  return 'black';
}

function searchCategories(request, callback) {
  var result = [];
  var re = new RegExp( '^' + request.term + '.*$', 'i' );
  for (i in all_categories) {
    if (re.test(all_categories[i].label)) {
      result.push(all_categories[i]);
    }
  }

  callback(result);
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

function initPie() {
  var r = Raphael("pie"), values = [], legend = [], links = [], colors = [];

  for (i in pie_categories) {
    if (pie_categories[i].percentage == 0) {
      continue;
    }

    values.push(pie_categories[i].percentage);
    legend.push(pie_categories[i].expenses + 'zł ' + pie_categories[i].label);
    links.push( '/categories/' + pie_categories[i].id );
    colors.push( pie_categories[i].color );
  }

  r.g.txtattr.font = "0.9em 'Fontin Sans', Fontin-Sans, sans-serif";

  var pie = r.g.piechart(350, 175, 140, values, {
    legend: legend,
    legendpos: "west",
    href: links,
    colors: colors
  });
  pie.hover(function () {
    this.sector.stop();
    this.sector.scale(1.1, 1.1, this.cx, this.cy);
    if (this.label) {
      this.label[0].stop();
      this.label[0].scale(1.5);
      this.label[1].attr({"font-weight": 800});
    }
  }, function () {
    this.sector.animate({scale: [1, 1, this.cx, this.cy]}, 500, "bounce");
    if (this.label) {
      this.label[0].animate({scale: 1}, 500, "bounce");
      this.label[1].attr({"font-weight": 400});
    }
  });
}

$(function() {
  $.datepicker.setDefaults({ dateFormat: 'yy-mm-dd' });
  $('.button').button();
  $('.buttonset').buttonset();
  $('#transaction_date').datepicker();
  $('#transaction_category_name').autocomplete({
    delay: 0,
    source: searchCategories,
    open: autocompleteopen
  });

  setTimeout(function() {
    $('#notice').hide("fade", {}, 1000);
  }, 1000);

  var wheel = $('#colorwheel');
  if (wheel.length) {
    initWheel(wheel);
  }

  var pie = $('#pie');
  if (pie.length) {
    initPie(pie);
  }
});
