module Rubiks
  class CubieFactory
    def build(geometric_cube)
      cubie_faces = cubie_face_factory.build(geometric_cube.points)
      Cubie.new(geometric_cube, cubie_faces)
    end

    def cubie_face_factory
      @cubie_face_factory ||= CubieFaceFactory.new(cube_face_characteristics)
    end

    def cube_face_characteristics
      @cube_face_characteristics ||= CubeFaceCharacteristicsFactory.new.build
    end
  end
end