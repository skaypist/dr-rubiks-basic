class CubieRenderer
  attr_reader :cubie

  def self.render(cubie)
    new(cubie).render
  end

  def initialize(cubie)
    @cubie = cubie
  end

  def render
    cubie.nearest_faces.each do |face|
      render_face(face)
    end
  end

  def render_face(face)
    points = face.points
    edges = points
              .cycle
              .each_cons(2)
              .take(4)
              .sort_by { |(a,b)| [a.z, b.z].min }

    edges.first(2)
         .each {|(a,b)| output_edge(a,b, face.color) }


    edges.last(2)
         .each {|(a,b)| output_edge(a,b, face.color) }


    points[1..-1].each_cons(2) do |(b, c)|
      output_triangle(points.first, b, c, face.color)
    end
  end

  def output_edge(a, b, color)
    $render_buffer << {
      x:  a.x,
      y:  a.y,
      x2: b.x,
      y2: b.y,
      z: [[a.z, b.z].min, 1],
      primitive_marker: :line,
    }.merge(color.darken(0.5).to_h)
  end

  def output_triangle(a, b, c, color)
    $render_buffer << {
      x:  a.x,
      y:  a.y,
      x2: b.x,
      y2: b.y,
      x3: c.x,
      y3: c.y,
      z: [[a.z, b.z, c.z].min, 0],
      primitive_marker: :solid,
    }.merge(color.to_h)
  end
end