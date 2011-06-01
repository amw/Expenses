$ ->
  return unless $('#pie').size()

  values = []
  legend = []
  links = []
  colors = []

  for id, category of pie_categories
    continue if category.percentage == 0

    values.push category.percentage
    legend.push category.value + "z\u0142 " + category.label
    links.push '/categories/' + category.id
    colors.push category.color

  r = Raphael "pie"

  pie = r.g.piechart 470, 175, 150, values,
    legend: legend,
    legendpos: "west",
    href: links,
    colors: colors

  .hover \
    ->
      @sector.stop()
      @sector.scale(1.1, 1.1, @cx, @cy)
      if @label
        @label[0].stop()
        @label[0].scale(1.5)
        @label[1].attr({"font-weight": 300})
    , ->
      @sector.animate({scale: [1, 1, @cx, @cy]}, 500, "bounce")
      if (@label)
        @label[0].animate({scale: 1}, 500, "bounce")
        @label[1].attr({"font-weight": 100})

  pie.labels.translate -100, 0
