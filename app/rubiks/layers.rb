module Rubiks
  class Layers
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