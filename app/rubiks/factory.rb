module Rubiks
  class Factory
    include MatrixFunctions

    attr_reader :center_corner, :block_size
    def initialize(center_corner, block_size)
      @center_corner, @block_size = center_corner, block_size
    end

    def build
      cubies = build_cubies
      layers = layers(cubies)
      initial_transform = QuaternionPose.build_initial(bases, center_corner)
      Cube.new(cubies, layers, initial_transform)
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

    def layers(cubies)
      LayersManagerFactory.new(cubies, bases, center_corner).build
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

    def big_cubie
      @big_cubie ||= calculate_big_cubie
    end

    def calculate_big_cubie
      cube_corner = (center_corner - bases.reduce(&:+)).round
      cube_bases = bases.map { |b| (b*3.0).round }
      big_cube = Cubes::Factory.build(cube_corner , cube_bases)
      CubieFactory.new(bases, center_corner).build(big_cube)
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