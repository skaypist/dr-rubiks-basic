module Rubiks
  class CubieFace < ::PointSet
    attr_reader :color, :characteristic

    def initialize(geometric_face, color, characteristic)
      @points = geometric_face.to_a
      @color = color
      @characteristic = characteristic
    end
  end
end