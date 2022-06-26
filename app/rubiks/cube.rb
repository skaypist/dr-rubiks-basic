module Rubiks
  class Cube
    attr_reader :cubies, :layers, :transforms

    def initialize(cubies, layers, initial_transform, faces: [])
      @cubies = cubies
      @layers = layers
      @transforms = []
      @transforms << initial_transform
      @faces = faces
    end

    def second_transform=(second_pose)
      if @transforms.length == 1
        @transforms << second_pose
      else
        @transforms[1] = second_pose
      end
    end

    def collapse_pose!
      if @transforms[1]
        @transforms[0] = @transforms[1] * @transforms[0]
        @transforms.delete_at(1)
      end
    end

    def farthest_cubies_first
      cubies.sort_by {|c| c.nearest_corner.z }
    end

    def nearest_cubie
      cubies.max_by {|c| c.nearest_corner.z }
    end

    def layer(i)
      layers.get_layer(i)
    end

    def reset!
      cubies.each(&:reset!)
    end

    def rotate(**kwargs)
      cubies.each do |c|
        c.rotate(**kwargs)
      end
    end
  end
end
