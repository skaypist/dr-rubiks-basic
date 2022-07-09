module Rubiks
  module CheckFaceContains
    def contains?(point)
      between_first_pair?(point) &&
        between_second_pair?(point)
    end

    def between_first_pair?(point)
      ray_test(point, line_between(0,1)) != ray_test(point, line_between(3, 2))
    end

    def between_second_pair?(point)
      ray_test(point, line_between(3,0)) != ray_test(point, line_between(2, 1))
    end

    def ray_test(point, line)
      $gtk.args.geometry.ray_test(
        point.except(:z),
        line
      )
    end

    def line_between(i, j)
      points[i].to_h.except(:z).
        merge(x2: points[j].x, y2: points[j].y)
    end
  end

  class CubieFace < ::PointSet
    include CheckFaceContains
    attr_accessor :color
    attr_reader :characteristic, :points

    def initialize(geometric_face, color, characteristic)
      @points = geometric_face.to_a
      @color = color
      @characteristic = characteristic
    end

    def inspect
      {
        characteristic: characteristic.inspect,
        color: color.name,
      }.to_s
    end

    def center
      points.reduce(&:+)*0.25
    end
  end
end