module Rubiks
  class CubieFace
    attr_reader :geometric_face, :color, :characteristic

    def initialize(geometric_face, color, characteristic)
      @geometric_face = geometric_face
      @color = color
      @characteristic = characteristic
    end
  end
end