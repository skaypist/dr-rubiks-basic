module Rubiks
  class Cubie
    attr_reader :geometric_cube, :faces

    def initialize(geometric_cube, cubie_faces)
      @geometric_cube = geometric_cube
      @faces = cubie_faces
    end

    def visible_faces
      current_nearest_corner = nearest_corner
      faces.select { |f| f.points.find { |fp| fp == current_nearest_corner } }
    end

    def nearest_corner
      geometric_cube.nearest_corner
    end

    def rotate(**opts)
      geometric_cube.rotate(**opts)
    end

    def reset!
      geometric_cube.reset!
    end

    def layer_characteristics
      geometric_cube.
        initial.
        min_by(&:mag2).
        map { |k,v| {}.tap {|h| h[k] = v} }
    end
  end
end