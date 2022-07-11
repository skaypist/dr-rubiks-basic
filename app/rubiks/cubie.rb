module Rubiks
  class Cubie
    include MatrixFunctions
    include ::Posing::Rotatable

    attr_accessor :geometric_cube, :faces

    def initialize(geometric_cube, cubie_faces)
      @geometric_cube = geometric_cube
      @faces = cubie_faces
    end

    def nearest_faces
      current_nearest_corner = nearest_corner
      faces.select { |f| f.points.find { |fp| fp.eql? current_nearest_corner } }
    end

    def nearest_corner
      geometric_cube.nearest_corner
    end

    def rotate(**opts)
      geometric_cube.rotate(**opts)
    end

    def center_cubie
      nil
    end

    def cubies
      [self]
    end

    def points
      geometric_cube.points
    end

    def reset!
      geometric_cube.reset!
    end

    def initial_center
      @initial_center ||= (geometric_cube.initial.points.reduce(&:+) * 0.125).round
    end

    def center
      geometric_cube.points.reduce(&:+) * 0.125
    end

    def outside_faces
      faces.select { |f| f.color.name != :black }
    end

    def tclone
      cloned_faces = faces.map do |face|
        CubieFace.new(face.points, face.color.clone, face.characteristic.clone)
      end
      self.class.new(geometric_cube, cloned_faces)
    end

    def cubie_characteristic
      @cubie_characteristic ||= initial_center.round.to_a.map { |(k,v)| [[k,v]].to_h}.
        map { |h| CharacteristicRegistry.register(h) }
    end

    def face_characteristics
      @face_characteristics ||= outside_faces.map(&:characteristic)
    end

    def inspect
      {
        colors: outside_faces.map {|o_f| o_f.color.name }.uniq.join(", "),
        initial_center: initial_center
      }.to_s
    end
  end
end