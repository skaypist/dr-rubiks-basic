module Rubiks
  class LayerFactory
    attr_reader :cube, :layer_characteristics, :bases, :center_corner

    def initialize(rubiks_cube, bases, center_corner)
      @cube = rubiks_cube
      @center_corner = center_corner
      @bases = bases
      @layer_characteristics = calculate_layer_characteristics
      calculate_layers
    end

    def calculate_layer_characteristics
      bases
        .product([-1, 0, 1])
        .map { |(base, c)| (base * c) + center_corner }
        .map do |offset_base|
          offset_base.map { |k, v| Hash.new.tap { |h| h[k] = v } }
        end.flatten(1).uniq
    end

    def calculate_layers
      @layers = {}
      layer_characteristics.each.with_index do |lc, i|
        @layers[lc] = cube.cubies.select do |cubie|
          cubie.layer_characteristics.include?(lc)
        end
      end

      debug_layers
    end

    def debug_layers
      new_object_ids = @layers.values.map(&:object_id).flatten - cube.cubies.map(&:object_id)
      puts "new_object_ids"
      puts (new_object_ids).count
      puts "@layers.values.count"
      puts @layers.values.flatten(1).count
    end

    def get_layer(i)
      @layers[@layers.keys[i]]
    end
  end
end
