module Rubiks
  class CubieFace < ::PointSet
    attr_accessor :color
    attr_reader :characteristic, :points

    def initialize(geometric_face, color, characteristic)
      @points = geometric_face.to_a
      @color = color
      @characteristic = characteristic
    end

    def inspect
      {
        characteristic: characteristic,
        color: color.name,
      }
    end
  end
end