module Rubiks
  class Factory
    include MatrixFunctions

    attr_reader :center_corner, :block_size
    def initialize(center_corner, block_size)
      @center_corner, @block_size = center_corner, block_size
    end

    def build
      Cube.new(*build_geometric_cubes)
    end

    def build_geometric_cubes
      (1..3).to_a.map do |dim_count|
        bases
          .product([-1, 1])
          .map { |d, c| d*c }
          .combination(dim_count)
          .map {|combo| combo.reduce(center_corner, &:+) }
          .map {|block_corner| Cubes::Factory.build(block_corner, bases) }
      end.flatten(1).uniq { |c| c.corner}
    end

    def bases
      @bases ||= [
        vec3(block_size,0,0),
        vec3(0,block_size,0),
        vec3(0,0,block_size)
      ]
    end
  end

  def stash_build_geometric_cubes
    (1..3).to_a.map do |dim_count|
      bases
        .combination(dim_count)
        .to_a
        .product([-1, 1])
        .map { |d, c| d.map { |di| di*c }.reduce(center_corner, &:+) }
        .map {|block_corner| Cubes::Factory.build(block_corner, bases) }
    end.flatten(1)
  end
end