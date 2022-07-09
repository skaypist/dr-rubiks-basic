module Rubiks
  class Layer
    include Enumerable
    include MatrixFunctions
    include ::Posing::Rotatable

    attr_reader :cubies, :cubie_characteristic, :edge_face_characteristics, :outside_face_characteristic
    def initialize(
      edge_cubies:,
      center_cubie:,
      cubie_characteristic:,
      edge_face_characteristics:,
      outside_face_characteristic:
    )
      @edge_cubies, @center_cubie, @cubie_characteristic =
        edge_cubies, center_cubie, cubie_characteristic
      @edge_face_characteristics = edge_face_characteristics
      @outside_face_characteristic = outside_face_characteristic
      puts outside_face_characteristic.inspect
      @cubies = @edge_cubies + [center_cubie]
    end

    def each
      if block_given?
        @cubies.each { |cubie| yield cubie }
        return
      end

      @cubies.each
    end

    def by_coordinates(coordinates, face_char)
      find do |cubie|
        cubie.faces.
          find { |face| face.characteristic == face_char }.
          contains?(coordinates)
      end
    end

    def center
      center_cubie.center
    end

    def axis
      @external_cubie_face ||= calculate_external_cubie_face
      @external_cubie_face.center - center
    end

    def calculate_external_cubie_face
      outside_face_characteristic_keys = @edge_face_characteristics.map(&:key)
      center_cubie.faces.find do |face|
        !outside_face_characteristic_keys.include?(face.characteristic.key)
      end
    end

    def swap_stickers(sign)
      cloned_cubies = @edge_cubies.map(&:tclone)
      @edge_cubies.zip(cloned_cubies.rotate(-2*sign)).each do |(orig, copied)|
        shared_face_color = copied.outside_faces.find { |face| face.characteristic.key == cubie_characteristic.key }&.color&.clone
        orig.outside_faces.find { |face| face.characteristic.key == cubie_characteristic.key }&.color = shared_face_color if shared_face_color

        off_key_swap = cubie_characteristic.off_keys.zip(cubie_characteristic.off_keys.reverse)
        off_key_swap.each do |(source_key, dest_key)|
          next unless (complementary_face = copied.outside_faces.find { |face| face.characteristic.key == source_key })
          swap_face_color = complementary_face.color.clone
          orig.outside_faces.find { |face| face.characteristic.key == dest_key }&.color = swap_face_color if swap_face_color
        end
      end
    end

    attr_reader :edge_cubies, :center_cubie
  end
end