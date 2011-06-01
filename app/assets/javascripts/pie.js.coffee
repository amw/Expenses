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
  r.g.txtattr.font = "0.9em 'Fontin Sans', Fontin-Sans, sans-serif"

  pie = r.g.piechart 350, 175, 140, values,
    legend: legend,
    legendpos: "west",
    href: links,
    colors: colors
    centered: true

  pie.hover \
    ->
      @sector.stop()
      @sector.scale(1.1, 1.1, @cx, @cy)
      if @label
        @label[0].stop()
        @label[0].scale(1.5)
        @label[1].attr({"font-weight": 800})
    , ->
      @sector.animate({scale: [1, 1, @cx, @cy]}, 500, "bounce")
      if (@label)
        @label[0].animate({scale: 1}, 500, "bounce")
        @label[1].attr({"font-weight": 400})
