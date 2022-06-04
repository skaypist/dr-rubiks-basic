module Rubiks
  class Cube
    attr_reader :cubes

    def initialize(*cubes)
      @cubes = cubes
    end

    def reset!
      @cubes.each(&:reset!)
    end

    def rotate(around:, at:, by:)
      @cubes.each do |c|
        c.rotate(around: around, at: at, by: by)
      end
    end

    def cubies
      @cubes
    end

    def farthest_cubies_first
      @cubes.sort_by {|c| c.nearest_corner.z }
    end

    def farthest_starting_cubies_first
      @cubes.sort_by {|c| c.nearest_starting_corner.z }
    end
  end
end