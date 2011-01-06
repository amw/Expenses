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

function initPie() {
  var r = Raphael("pie"), values = [], legend = [], links = [], colors = [];

  for (i in categories) {
    if (categories[i].percentage == 0) {
      continue;
    }

    values.push(categories[i].percentage);
    legend.push(categories[i].expenses + 'zł ' + categories[i].label);
    links.push( '/categories/' + categories[i].id );
    colors.push( categories[i].color );
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

  var pie = $('#pie');
  if (pie.length) {
    initPie(pie);
  }
});
