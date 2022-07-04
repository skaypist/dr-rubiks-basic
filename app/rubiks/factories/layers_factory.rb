module Rubiks
  class LayersFactory
    attr_reader :cubies

    def initialize(cubies)
      @cubies = cubies
    end

    def build
      raise "layers.count #{layers.count}" unless layers.count == 9
      raise "layers cube count bad #{layers.find {|l| l.count != 9}.count}" unless layers.all? {|l| l.count == 9}
      Layers.new(layers)
    end

    def all_layer_characteristics
      @all_layer_characteristics ||= cubies.flat_map(&:cubie_characteristic).uniq
    end

    def layers
      @layers ||= all_layer_characteristics.map do |lc|
        layer_cubies = cubies.select do |cubie|
          cubie.cubie_characteristic.include?(lc)
        end
        LayerFactory.new(lc, layer_cubies).build
      end
    end
  end
end