module Rubiks
  class Cubie
    attr_accessor :geometric_cube, :faces

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

    def initial_center
      geometric_cube.initial.points.reduce(&:+) * 0.1666
    end

    def outside_faces
      faces.select { |f| f.color.name != :black }
    end

    def subsume(cubie, layer_characteristic)
      f1 = outside_faces.find { |f| f.characteristic == layer_characteristic }
      f2 = cubie.outside_faces.find { |f| f.characteristic == layer_characteristic }
      f1.color = f2.color.clone

      remaining = outside_faces.
        select { |f| f.characteristic.keys.first != f1.characteristic.keys.first }.
        sort_by { |f| f.characteristic.keys.first }
      other_remaining = cubie.outside_faces.
        select { |f| f.characteristic.keys.first != f2.characteristic.keys.first }.
        sort_by { |f| f.characteristic.keys.first }.reverse
      remaining.zip(other_remaining).each do |(r, o)|
        r.color = o.color.clone
      end
    end

    def tclone
      cloned_faces = faces.map do |face|
        CubieFace.new(face.points, face.color.clone, face.characteristic.clone)
      end
      self.class.new(geometric_cube, cloned_faces)
    end

    def layer_characteristics
      geometric_cube.
        initial.
        min_by(&:mag2).
        map { |k,v| {}.tap {|h| h[k] = v} }
    end
  end
end