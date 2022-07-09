module Rubiks
  class Factory
    include MatrixFunctions

    def build
      cubies = build_cubies
      layers = layers(cubies)
      Cube.new(cubies, layers, big_cubie)
    end

    def build_cubies
      geometric_cubes = build_geometric_cubes
      geometric_cubes.map do |gc|
        cubie_factory.build(gc)
      end
    end

    def cubie_factory
      @_cubie_factory ||= CubieFactory.new
    end

    def layers(cubies)
      LayersFactory.new(cubies).build
    end

    def build_geometric_cubes
      (1..3).to_a.map do |dim_count|
        Config.bases
          .product([-1, 1])
          .map { |d, c| d*c }
          .combination(dim_count)
          .map {|combo| combo.reduce(Config.center_corner, &:+) }
          .map {|block_corner| Cubes::Factory.build(block_corner, Config.bases) }
      end.flatten(1).uniq { |c| c.initial.sort_by(&:mag2) }
    end

    def big_cubie
      @big_cubie ||= calculate_big_cubie
    end

    def calculate_big_cubie
      cube_corner = (Config.center_corner - Config.bases.reduce(&:+)).round
      cube_bases = Config.bases.map { |b| (b*3.0).round }
      big_cube = Cubes::Factory.build(cube_corner, cube_bases)
      CubieFactory.new.build(big_cube)
    end
  end
end