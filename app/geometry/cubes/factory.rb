module Cubes
  class Factory
    extend MatrixFunctions
    include MatrixFunctions
    include VectorHelpers

    attr_reader :corner, :size

    def initialize(corner, size)
      @corner, @size = corner, size
    end

    def self.build(corner, size)
      factory = new(corner, size)
      points = factory.calculate_cube_points
      initial_point_set = PointSet.new(*points)
      mutable_points = MutablePointSet.from_points(*points)
      faces = factory.calculate_face_point_sets(mutable_points)
      Cube.new(
        initial: initial_point_set,
        mutable: mutable_points,
        faces: faces
      )
    end

    def bases
      @bases ||= [
        vec3(size,0,0),
        vec3(0,size,0),
        vec3(0,0,size)
      ]
    end

    def calculate_cube_points
      [0, 1, 2, 3].map do |dim_count|
        combos = bases.combination(dim_count).to_a
        combos.map do |combo|
          if combo.any?
            sum =combo.reduce do |base, bi|
              add(base, bi)
            end

            add(corner, sum)
          else
            [corner]
          end
        end
      end.flatten
    end

    def calculate_face_point_sets(mutable_point_set)
      mutable_point_set
        .mutable_points
        .combination(4)
        .to_a
        .keep_if do |potential_face_points|
        matching_xs = (potential_face_points.map { |p| p.value.x }.uniq.count == 1)
        matching_ys = (potential_face_points.map { |p| p.value.y }.uniq.count == 1)
        matching_zs = (potential_face_points.map { |p| p.value.z }.uniq.count == 1)
        (matching_xs || matching_ys || matching_zs)
      end.map do |face_points|
        fps = face_points.sort_by { |fp| mag2(fp.value) }
        MutablePointSet.new(fps[0], fps[1], fps[3], fps[2])
      end
    end
  end
end