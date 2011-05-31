$ ->
  return unless $('#pie').size()

  values = []
  legend = []
  links = []
  colors = []

  for id, category of pie_categories
    continue if category.percentage == 0

    values.push category.percentage
    legend.push category.expenses + "z\u0142 " + category.label
    links.push '/categories/' + category.id
    colors.push category.color

  r = Raphael "pie"
  r.g.txtattr.font = "0.9em 'Fontin Sans', Fontin-Sans, sans-serif"

  pie = r.g.piechart 350, 175, 140, values,
    legend: legend,
    legendpos: "west",
    href: links,
    colors: colors

  pie.hover \
    ->
      this.sector.stop()
      this.sector.scale(1.1, 1.1, this.cx, this.cy)
      if this.label
        this.label[0].stop()
        this.label[0].scale(1.5)
        this.label[1].attr({"font-weight": 800})
    , ->
      this.sector.animate({scale: [1, 1, this.cx, this.cy]}, 500, "bounce")
      if (this.label)
        this.label[0].animate({scale: 1}, 500, "bounce")
        this.label[1].attr({"font-weight": 400})
