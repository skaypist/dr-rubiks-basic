module Rubiks
  class CubieFaceFactory
    attr_reader :cube_face_characteristics

    def initialize(cube_face_characteristics)
      @cube_face_characteristics = cube_face_characteristics
    end

    def build(cube_points)
      build_polygons(cube_points).map do |polygon|
        characteristic = CharacteristicRegistry.register(cube_face_characteristic(polygon))
        color = (characteristic_to_mapping[characteristic.value] || Colors::BLACK).clone
        CubieFace.new(polygon, color, characteristic)
      end
    end

    def build_polygons(cube_points)
      cube_points
        .to_a
        .combination(4)
        .to_a
        .keep_if do |potential_face_points|
        cube_face_characteristic(potential_face_points).any?
      end.map do |face_points|
        fps = face_points.sort_by { |fp| fp.mag2 }
        PointSet.new(fps[0], fps[1], fps[3], fps[2])
      end
    end

    def cube_face_characteristic(potential_face_points)
      first, *rest = *potential_face_points
      values_by_dims = {}
      %i[x y z].each do |dim|
        matching = rest.all? { |p| p[dim] == first[dim] }
        values_by_dims[dim] = first[dim] if matching
      end
      values_by_dims.compact
    end

    def characteristic_to_mapping
      @characteristic_to_mapping ||= cube_face_characteristics
                                       .zip(face_colors)
                                       .to_h
    end

    def face_colors
      [
        Colors::RED,
        Colors::CYAN,
        Colors::FUCHSIA,
        Colors::WHITE,
        Colors::LIME,
        Colors::YELLOW
      ]
    end
  end

  class CubeFaceCharacteristicsFactory
    def build
      cube_face_characteristics
    end

    def full_cube_bases
      @full_cube_bases ||= Config.bases
                        .product([-1, 2])
                        .map { |(base, sign)| base * sign }
    end

    def cube_face_characteristics
      full_cube_bases.map do |signed_base|
        face_pt = signed_base + Config.center_corner
        dim = signed_base.find { |_k, v| v != 0 }.first
        Hash.new.tap {|h| h[dim] = face_pt[dim] }
      end
    end
  end
end