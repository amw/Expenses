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
        @line.animate 'stroke-width': 4, 400, '>'
        @symbol.animate r: 8, 400, '>'
        $(".cat-#{category_id(@line)}").animate width: '90%', 200
      , ->
        @tag && @tag.remove()
        @line.animate 'stroke-width': 2, 400, '>'
        @symbol.animate r: 4, 400, '>'
        $(".cat-#{category_id(@line)}").animate width: '80%', 200

    category_id = (line) ->
      for id, test_line of chart.lines
        return categories[id] if line == test_line

    chart.symbols.attr r: 4

    console.log chart

    i = 0
    chart.eachColumn ->
      t = r.text @x, 530, months[i++]
      t.attr Raphael.fn.g.txtattr

  drawChart()

  $('#trends_legend span').click ->
    $(this).toggleClass 'selected'
    $('#trends').html ''
    drawChart()

