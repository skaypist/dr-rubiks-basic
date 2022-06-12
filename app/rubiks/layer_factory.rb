module Rubiks
  class LayersFactory
    attr_reader :cubies, :bases, :center_corner

    def initialize(cubies, bases, center_corner)
      @cubies = cubies
      @center_corner = center_corner
      @bases = bases
    end

    def center
      (center_corner + bases.reduce(&:+)*0.5)
    end

    def build
      Layers.new(calculate_layers(calculate_layer_characteristics), center)
    end

    def calculate_layer_characteristics
      bases
        .product([-1, 0, 1])
        .map { |(base, c)| (base * c) + center_corner }
        .map do |offset_base|
          offset_base.map { |k, v| Hash.new.tap { |h| h[k] = v } }
        end.flatten(1).uniq
    end

    def calculate_layers(layer_characteristics)
      layers_hash = {}
      layer_characteristics.each do |lc|
        layers_hash[lc] = cubies.select do |cubie|
          cubie.layer_characteristics.include?(lc)
        end
      end
      layers_hash
    end
  end

  class Layers
    attr_reader :layer_hash
    attr_accessor :actively_posed

    def initialize(layer_hash, center)
      @layer_hash = layer_hash.map do |k, v|
        [k, Layer.new(v, k, center)]
      end.to_h
      @actively_posed = []
    end

    def get_layer(i)
      @layer_hash[@layer_hash.keys[i]]
    end

    def rotate(i, angle)
      @actively_posed = get_layer(i)
      @actively_posed.transform.by = @actively_posed.transform.by + angle
    end
  end

  class Layer
    include ::Enumerable
    include MatrixFunctions
    attr_reader :cubies, :transform, :characteristic

    def initialize(cubies, characteristic, center)
      @characteristic = characteristic
      @cubies = cubies
      separate_edge_cubies!
      sort_radially!
      around_hash = vec3(*{x: 0, y:0, z: 0}.merge(characteristic).values)
      around = normalize(vec3(around_hash[:x], around_hash[:y], around_hash[:z]))
      @transform = ::Pose.new(
        at: center,
        around: around,
        by: 0
      )
    end

    def sort_radially!
      layer_center = initial_layer_center
      zero_degrees_3d = (@edge_cubies.first.initial_center.merge(characteristic) - layer_center)
      zero_deg_2d_pairs = zero_degrees_3d.map.reject do |k, _v|
        k == characteristic.keys.first
      end.map do |(k, v)|
        v
      end
      zero_degrees = normalize(vec2(*zero_deg_2d_pairs))
      @edge_cubies = @edge_cubies.sort_by do |cubie|
        ray_3d = (cubie.initial_center.merge(characteristic) - layer_center)
        ray_2d_pairs = ray_3d.map.reject do |k, _v|
          k == characteristic.keys.first
        end.sort.map do |(k, v)|
          v
        end
        ray = vec2(*ray_2d_pairs)
        $gtk.args.geometry.angle_to(zero_degrees, ray).round % 360
      end
    end

    def initial_layer_center
      (cubies.map{ |cubie| cubie.initial_center }.flatten(1).reduce(&:+) * 0.1111111).
        merge(characteristic)
    end

    def each
      @cubies.each { |cubie| yield cubie } if block_given?
      @cubies.each
    end

    def separate_edge_cubies!
      first, *rest = cubies.sort_by do |cubie|
        (initial_layer_center - cubie.initial_center.merge(characteristic)).mag2
      end
      @edge_cubies = rest
      @center_cubie = first
    end

    def swap_stickers(sign)
      cloned_cubies = @edge_cubies.map(&:tclone)
      @edge_cubies.zip(cloned_cubies.rotate(2*sign)).each do |(orig, copied)|
        orig.subsume(copied, characteristic)
      end
    end
  end
end
