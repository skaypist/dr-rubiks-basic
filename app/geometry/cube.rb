class Cube
  extend MatrixFunctions

  def self.build_simple(corner, size)
    bases = [
      vec3(size,0,0),
      vec3(0,size,0),
      vec3(0,0,size)
    ]
    # blank_bases = Array.new(3, Point.new(*Array.new(3,0)))
    # bases = blank_bases.map.with_index do |p, i|
    #   offset = Array.new(3,0)
    #   offset[i] = size
    #   p + Point.new(*offset)
    # end

    cube_points = [0, 1, 2, 3].map do |dim_count|
      combos = bases.combination(dim_count).to_a
      combos.map do |combo|
        if (combo.any?)
          sum =combo.reduce do |base, bi|
            add(base, bi)
          end

          add(corner, sum)
        else
          [corner]
        end
      end
    end.flatten

    PointSet.new(*cube_points)
  end

  def primitives
    points.map { |p| GraphicalPoint.new(p).primitive }
  end
end
