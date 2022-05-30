
LINE_ORDER = {
  line: 0,
  solid: 1,
}

class PolygonRenderer
  def initialize(polygon_point_set)
    @polygon_point_set = polygon_point_set
  end

  def render
    edges = points
      .cycle
      .each_cons(2)
      .take(4)
      .sort_by { |(a,b)| [a.z, b.z].min }

    edges.first(2)
         .each {|(a,b)| output_edge(a,b) }



    edges.last(2)
         .each {|(a,b)| output_edge(a,b) }


    points[1..-1].each_cons(2) do |(b, c)|
      output_triangle(points.first, b, c)
    end
    # points
    #   .cycle
    #   .each_cons(2)
    #   .take(4)
    #   .each {|(a,b)| output_edge(a,b) }

    # points
    #   .cycle
    #   .each_cons(2)
    #   .take(4)
    #   .sort_by { |(a,b)| [a.z, b.z].max }
    #   .first(2)
    #   .each {|(a,b)| output_edge(a,b) }

    # i = points.index(@polygon_point_set.nearest_corner)

    # irange = (i-1)..(i+1)
    # points[irange].each_cons(2).take(2).each do |(a,b)|
    #   output_edge(a,b)
    # end
  end

  def output_edge(a,b)
    # $gtk.args.state.z_primitives << {
    $render_buffer << {
      x:  a.x,
      y:  a.y,
      x2: b.x,
      y2: b.y,
      r:  150,
      g:  75,
      b:  22,
      z: [[a.z, b.z].min, 1],
      # z: [a.z, b.z].min,
      primitive_marker: :line,
    }
  end

  def output_triangle(a, b, c)
    # $gtk.args.state.z_primitives << {
    $render_buffer << {
      x:  a.x,
      y:  a.y,
      x2: b.x,
      y2: b.y,
      x3: c.x,
      y3: c.y,
      r:  200,
      g:  100,
      b:  30,
      z: [[a.z, b.z, c.z].min, 0],
      # z: [a.z, b.z, c.z].min,
      primitive_marker: :solid,
    }
  end

  private

  attr_reader :polygon_point_set

  def points
    @_points ||= polygon_point_set.points
  end
end