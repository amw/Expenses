$ ->
  return unless $('#trends').size()

  chart = null

  drawChart = ->
    selected_categories = $('#trends_legend span.selected').map ->
      $(this).data 'category-id'

    colors     = []
    columns    = []
    values     = []
    categories = []
    months     = (month.name for id, month of trends_months)

    for id, val of trends_values
      continue unless parseInt(id) in selected_categories
      categories.push id
      values.push val
      colors.push all_categories[id]['color']
      columns.push [0,1,2,3,4,5]

    r = Raphael "trends"

    chart = r.g.linechart \
      30, 0, 500, 530,
      columns,
      values,
        colors: colors,
        axis: "0 0 0 1",
        symbol: 'o',
        smooth: false,
        gutter: 20

    .hover \
      ->
        @tag && @tag.remove()
        @tag = r.g.tag(@x, @y, @value, 190, 10)
          .insertBefore(this)
          .attr([{fill: "#fff"}, {fill: @symbol.attr("fill")}])
        @line.stop().animate 'stroke-width': 4, 300, '>'
        @symbol.stop().animate r: 8, 300, '>'
        $(".cat-#{category_id(@line)}").stop().animate width: '90%', 300
      , ->
        @tag && @tag.remove()
        @line.stop().animate 'stroke-width': 2, 300, '>'
        @symbol.stop().animate r: 4, 300, '>'
        $(".cat-#{category_id(@line)}").stop().animate width: '80%', 300

    category_id = (line) ->
      for id, test_line of chart.lines
        return categories[id] if line == test_line

    chart.symbols.attr r: 4

    i = 0
    chart.eachColumn ->
      t = r.text @x, 530, months[i++]
      t.attr Raphael.fn.g.txtattr

  drawChart()

  $('#trends_legend span').click ->
    $(this).toggleClass 'selected'
    $('#trends').html ''
    drawChart()

