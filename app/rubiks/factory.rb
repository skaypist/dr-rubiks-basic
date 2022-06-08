module Rubiks
  class Factory
    include MatrixFunctions

    attr_reader :center_corner, :block_size
    def initialize(center_corner, block_size)
      @center_corner, @block_size = center_corner, block_size
    end

    def build
      Cube.new(*build_cubies)
    end

    def build_cubies
      geometric_cubes = build_geometric_cubes
      geometric_cubes.map do |gc|
        cubie_factory.build(gc)
      end
    end

    def cubie_factory
      @_cubie_factory ||= CubieFactory.new(bases, center_corner)
    end

    def build_geometric_cubes
      (1..3).to_a.map do |dim_count|
        bases
          .product([-1, 1])
          .map { |d, c| d*c }
          .combination(dim_count)
          .map {|combo| combo.reduce(center_corner, &:+) }
          .map {|block_corner| Cubes::Factory.build(block_corner, bases) }
      end.flatten(1).uniq { |c| c.initial.sort_by(&:mag2) }
    end

    def bases
      @bases ||= [
        vec3(block_size,0,0),
        vec3(0,block_size,0),
        vec3(0,0,block_size)
      ]
    end
  end
end