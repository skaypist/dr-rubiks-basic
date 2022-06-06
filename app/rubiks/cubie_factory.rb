module Rubiks
  class CubieFactory
    attr_reader :bases, :center_corner

    def initialize(bases, center_corner)
      @bases, @center_corner = bases, center_corner
    end

    def build(geometric_cube)
      cubie_faces = geometric_cube.faces.map do |g_face|
        # maybe extract into cubie face factory
        characteristic = g_face.calculate_shared
        color = characteristic_to_mapping[characteristic] || Colors::BLACK
        CubieFace.new(g_face, color, characteristic)
      end
      Cubie.new(geometric_cube, cubie_faces)
    end

    def characteristic_to_mapping
      @characteristic_to_mapping ||= cube_face_characteristics
        .zip(face_colors)
        .to_h
    end

    def cube_face_characteristics
      bases
        .product([-1, 2])
        .map { |(base, sign)| base * sign }
        .map do |signed_base|
          face_pt = signed_base + center_corner
          dim = signed_base.find { |_k, v| v != 0 }.first
          Hash.new.tap {|h| h[dim] = face_pt[dim] }
      end
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
end