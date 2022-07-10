module Rubiks
  class Layers
    attr_reader :layers

    def initialize(layers)
      @layers = layers
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

    def by_characteristic(key)
      layers.
        select { |layer| layer.cubie_characteristic.key == key }.
        sort_by { |layer| layer.center_cubie.center.z }
    end
  end
end