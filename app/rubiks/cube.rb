module Rubiks
  class Cube
    include ::Posing::Rotatable
    attr_reader :cubies, :layers, :big_cubie

    def initialize(cubies, layers, big_cubie)
      @cubies = Cubies.new(cubies)
      @layers = layers
      @big_cubie = big_cubie
    end

    def center_cubie
      @center_cubie ||= cubies.min_by do |cubie|
        (cubie.center - center).mag2
      end
    end

    def center
      Config.center
    end

    def farthest_cubies_first
      cubies.sort_by {|c| c.nearest_corner.z }
    end

    def nearest_cubie
      cubies.max_by {|c| c.nearest_corner.z }
    end

    def reset!
      cubies.each(&:reset!)
    end
  end
end
