module Rubiks
  class Cube
    attr_reader :cubies

    def initialize(*cubies)
      @cubies = cubies
    end

    def reset!
      cubies.each(&:reset!)
    end

    def rotate(around:, at:, by:)
      cubies.each do |c|
        c.rotate(around: around, at: at, by: by)
      end
    end

    def farthest_cubies_first
      cubies.sort_by {|c| c.nearest_corner.z }
    end
  end
end