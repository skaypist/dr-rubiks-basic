module Rubiks
  class LayersManagerFactory
    attr_reader :cubies, :bases, :center_corner

    def initialize(cubies, bases, center_corner)
      @cubies = cubies
      @center_corner = center_corner
      @bases = bases
    end

    def center
      # center for cube
      # should be somewhere else
      (center_corner + bases.reduce(&:+)*0.5)
    end

    def build
      tlayers = layers
      raise "layers.count #{tlayers.count}" unless tlayers.count == 9
      raise "layers cube count bad #{tlayers.find {|l| l.count != 9}.count}" unless tlayers.all? {|l| l.count == 9}
      LayerManager.new(tlayers)
    end

    def layer_characteristics
      @layer_characteristics ||= bases
        .product([-1, 0, 1])
        .map { |(base, c)| (base * c) + center_corner }
        .map do |offset_base|
          offset_base.map { |k, v| Hash.new.tap { |h| h[k] = v } }
            .map { |h| CharacteristicRegistry.register(h) }
        end.flatten(1).uniq
    end

    def layers
      layer_characteristics.map do |lc|
        layer_cubies = cubies.select do |cubie|
          cubie.layer_characteristics.include?(lc)
        end
        LayerFactory.new(lc, center, layer_cubies).build
      end
    end
  end

  class LayerFactory
    include MatrixFunctions
    attr_reader :layer_center, :characteristic, :cubies, :cube_center

    def initialize(characteristic, cube_center, cubies)
      @characteristic = characteristic
      @cube_center = cube_center
      @layer_center = cube_center.merge(characteristic.value)
      @cubies = cubies
    end

    def build
      face_characteristics = edge_cubies.map(&:face_characteristics).reduce(&:|)
      edge_face_characteristics = face_characteristics.reject do |face_characteristic|
        face_characteristic.key == characteristic.key
      end
      outside_face_characteristic = face_characteristics.find do |face_characteristic|
        face_characteristic.key == characteristic.key
      end

      cubie_characteristic = cubies.map(&:cubie_characteristic).reduce(&:&).first
      Layer.new(
        edge_cubies: ordered_edge_cubies,
        center_cubie: center_cubie,
        pose: initial_pose,
        cubie_characteristic: cubie_characteristic,
        edge_face_characteristics: edge_face_characteristics,
        outside_face_characteristic: outside_face_characteristic
      )
    end

    def initial_pose
      @initial_pose ||= ::Pose.new(
        at: layer_center,
        around: normalize(layer_center - cube_center),
        by: 0
      )
    end

    def edge_cubies
      @edge_cubies ||= by_outside_face_count.first(8)
    end

    def center_cubie
      @center_cubie ||= by_outside_face_count[8]
    end

    def by_outside_face_count
      @by_outside_face_count = cubies.sort_by { |cubie| -1*cubie.outside_faces.count }
    end

    def ordered_edge_cubies
      layer_center_2d = layer_center.except(characteristic.key).to_vec2
      edge_cubies.sort_by do |cubie|
        $gtk.args.geometry.angle_from(
          # vec2(*(cubie.initial_center.except(characteristic.key).values)),
          cubie.initial_center.to_h.except(characteristic.key).to_vec2,
          layer_center_2d
        ).round % 360
      end
    end
  end

  class LayerManager
    attr_reader :layers
    attr_accessor :actively_posed

    def initialize(layers)
      @layers = layers
      @actively_posed = []
    end

    def actively_posed
      @actively_posed || []
    end

    def get_layer(i)
      @layers[i]
    end

    def by_outside_face_char(face_char)
      layers.find do |layer|
        layer.outside_face_characteristic == face_char
      end
    end

    def by_cubies_and_face(cubies:, edge_face_char:)
      layers.find do |layer|
        matches_cubies = (layer.to_a & cubies).count == 2
        matches_face = layer.edge_face_characteristics.include?(edge_face_char)
        matches_cubies && matches_face
      end
    end

    def rotate(i, angle)
      @actively_posed = get_layer(i)
      @actively_posed.transform.by = @actively_posed.transform.by + angle
    end
  end
end
