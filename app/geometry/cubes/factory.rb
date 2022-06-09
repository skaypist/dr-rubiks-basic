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
      Cube.new(initial: initial, mutable: mutable) # faces: faces)
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
  end
end