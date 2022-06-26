module Rubiks
  class CubieFactory
    include CheckFaceContains
    attr_reader :bases, :center_corner

    def initialize(bases, center_corner)
      @bases, @center_corner = bases, center_corner
    end

    def build(geometric_cube)
      cubie_faces = cubie_face_factory.build(geometric_cube.points)
      Cubie.new(geometric_cube, cubie_faces)
    end

    def cubie_face_factory
      @cubie_face_factory ||= CubieFaceFactory.new(full_cube_bases, center_corner, cube_face_characteristics)
    end

    def cube_face_characteristics_factory
      @cube_face_characteristics_factory ||= CubeFaceCharacteristicsFactory.new(bases, center_corner)
    end

    def full_cube_bases
      @full_cube_bases ||= cube_face_characteristics_factory.full_cube_bases
    end

    def cube_face_characteristics
      @cube_face_characteristics ||= cube_face_characteristics_factory.build
    end
  end
end