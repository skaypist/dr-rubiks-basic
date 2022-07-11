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
        cubie_characteristic: cubie_characteristic,
        edge_face_characteristics: edge_face_characteristics,
        outside_face_characteristic: outside_face_characteristic,
        rotation_face: rotation_face
      )
    end

    def rotation_face
      canonical_point = center_cubie.geometric_cube.points.max_by do |point|
        distance(point, vec3(0, 3000, -3000))
        # with deep apologies to self and anyone else who reads this.
        # anyways this apparently works. change to, like vec3(0,0,0), then try and
        # rotate layers, and some will rotate wrong. I couldn't figure out why
      end

      center_cubie.faces.find do |cubie_face|
        has_point = cubie_face.points.find { |cubie_face_point| cubie_face_point == canonical_point }
        matches_key = cubie_face.characteristic.key == characteristic.key
        has_point && matches_key
      end
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
