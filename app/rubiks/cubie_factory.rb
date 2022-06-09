module Rubiks
  class CubieFactory
    attr_reader :bases, :center_corner

    def initialize(bases, center_corner)
      @bases, @center_corner = bases, center_corner
    end

    def build(geometric_cube)
      cubie_faces = cubie_face_factory.build(geometric_cube.points)
      Cubie.new(geometric_cube, cubie_faces)
    end

    def cubie_face_factory
      @cubie_face_factory ||= CubieFaceFactory.new(bases, center_corner)
    end
  end
end