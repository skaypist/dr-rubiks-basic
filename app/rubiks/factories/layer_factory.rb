module Rubiks
  class LayerFactory
    include MatrixFunctions

    attr_reader :layer_center, :characteristic, :cubies

    def initialize(characteristic, cubies)
      @characteristic = characteristic
      @layer_center = Config.center.merge(characteristic.value).to_vec3
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
      @initial_pose ||= ::Posing::QuaternionPose.build(
        at: layer_center,
        around: normalize(layer_center - Config.center),
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
      @by_outside_face_count ||= cubies.sort_by { |cubie| -1*cubie.outside_faces.count }
    end

    def ordered_edge_cubies
      layer_center_2d = layer_center.except(characteristic.key).to_vec2
      edge_cubies.sort_by do |cubie|
        $gtk.args.geometry.angle_from(
          cubie.initial_center.to_h.except(characteristic.key).to_vec2,
          layer_center_2d
        ).round % 360
      end
    end
  end
end
