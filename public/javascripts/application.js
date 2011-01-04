$(function() {
  $.datepicker.setDefaults({ dateFormat: 'yy-mm-dd' });
  $('.button').button();
  $('.buttonset').buttonset();
  $('#transaction_date').datepicker();
  setTimeout(function() {
    $('#notice').hide("puff", { direction: "horizontal" }, 1000);
  }, 1000);
});
