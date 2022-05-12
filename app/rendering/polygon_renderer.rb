class PolygonRenderer
  def initialize(polygon_point_set)
    @polygon_point_set = polygon_point_set
  end

  def render
    points[1..-1].each_cons(2) do |(b, c)|
      output_triangle(points.first, b, c)
    end
  end

  def output_triangle(a, b, c)
    $gtk.args.outputs.solids << {
      x:  a.x,
      y:  a.y,
      x2: b.x,
      y2: b.y,
      x3: c.x,
      y3: c.y,
      r:  200,
      g:  100,
      b:  30,
    }
  end

  private

  attr_reader :polygon_point_set

  def points
    polygon_point_set.points
  end
end