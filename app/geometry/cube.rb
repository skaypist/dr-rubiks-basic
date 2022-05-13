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

  def self.build_cube_faces(corner, size)
    cube_points = self.build_simple(corner, size).points

    faces_point_sets = cube_points
              .combination(4)
              .to_a
              .keep_if do |potential_face_points|
      matching_xs = (potential_face_points.map { |p| p.x }.uniq.count == 1)
      matching_ys = (potential_face_points.map { |p| p.y }.uniq.count == 1)
      matching_zs = (potential_face_points.map { |p| p.z }.uniq.count == 1)
      (matching_xs || matching_ys || matching_zs)
    end.map do |face_points|
      fps = face_points.sort_by { |fp| mag2(fp) }
      PointSet.new(fps[0], fps[1], fps[3], fps[2])
    end

    PolygonSet.new(*faces_point_sets)
  end

  def self.coordinates(v3)
    [v3.x, v3.y, v3.z]
  end

  def self.mag2(v3)
    coordinates(v3).map {|c| c*c }.sum
  end

  def primitives
    points.map { |p| GraphicalPoint.new(p).primitive }
  end
end
