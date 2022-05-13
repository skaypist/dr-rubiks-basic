class PolygonRenderer
  def initialize(polygon_point_set)
    @polygon_point_set = polygon_point_set
  end

  def render
    points[1..-1].each_cons(2) do |(b, c)|
      output_triangle(points.first, b, c)
    end

    points.cycle.each_cons(2).take(4).each do |(a,b)|
      output_edge(a,b)
    end
  end

  def output_edge(a,b)
    $gtk.args.state.z_primitives << {
      x:  a.x,
      y:  a.y,
      x2: b.x,
      y2: b.y,
      r:  150,
      g:  75,
      b:  22,
      z: [a.z, b.z].min,
      primitive_marker: :line,
    }
  end

  def output_triangle(a, b, c)
    $gtk.args.state.z_primitives << {
      x:  a.x,
      y:  a.y,
      x2: b.x,
      y2: b.y,
      x3: c.x,
      y3: c.y,
      r:  200,
      g:  100,
      b:  30,
      z: [a.z, b.z, c.z].min,
      primitive_marker: :solid,
    }
  end

  private

  attr_reader :polygon_point_set

  def points
    polygon_point_set.points
  end
end