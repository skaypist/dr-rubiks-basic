module Cubes
  class Factory
    include MatrixFunctions

    attr_reader :corner, :size, :bases

    def initialize(corner, bases)
      @corner, @bases = corner, bases
    end

    def self.build(corner, bases)
      factory = new(corner, bases)
      points = factory.calculate_cube_points
      initial = PointSet.new(*points)
      mutable = PointSet.new(*points.map { |p| p.dup })
      faces = factory.calculate_face_point_sets(mutable)
      Cube.new(initial: initial, mutable: mutable, faces: faces, corner: corner)
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
        .to_a
        .combination(4)
        .to_a
        .keep_if do |potential_face_points|
        Polygon.calculate_shared(potential_face_points).any?
      end.map do |face_points|
        fps = face_points.sort_by { |fp| fp.mag2 }
        Polygon.new(fps[0], fps[1], fps[3], fps[2])
      end
    end
  end
end