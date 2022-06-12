module Rubiks
  class Cube
    attr_reader :cubies, :layers, :transforms

    def initialize(cubies, layers, initial_transform)
      @cubies = cubies
      @layers = layers
      @transforms = []
      @transforms << initial_transform
    end

    def second_transform=(second_pose)
      if @transforms.length == 1
        @transforms << second_pose
      end

      transforms.second.at = second_pose.at
      transforms.second.by = second_pose.by
      transforms.second.around = second_pose.around
    end

    def collapse_cube!
      if @transforms[1]
        mat1 = RotationCache.rotation_matrix(
          around: @transforms[0].around,
          by: @transforms[0].by
        )
        mat2 = RotationCache.rotation_matrix(
          around: @transforms[1].around,
          by: @transforms[1].by
        )
        
      end
    end

    def farthest_cubies_first
      cubies.sort_by {|c| c.nearest_corner.z }
    end

    def layer(i)
      layers.get_layer(i)
    end

    def reset!
      cubies.each(&:reset!)
    end

    def rotate(around:, at:, by:)
      cubies.each do |c|
        c.rotate(around: around, at: at, by: by)
      end
    end
  end

  # Rename to Rotation or Pose or something
  # class Transform
  #   attr_reader :around, :at, :by
  #
  #   def initialize(around:, at:, by:)
  #     @around, @at, @by = around, at, by
  #   end
  #
  #   def apply(poseables)
  #     poseables.each(&:reset!)
  #     poseables.each do |poseable|
  #       poseable.rotate(around: around, at: at, by: by)
  #     end
  #
  #     posables.each do |poseable|
  #       poseable.transform&.apply(poseable)
  #     end
  #   end
  #
  #   def self.build_initial(bases, cube_corner)
  #     center = (cube_corner + bases.reduce(:+)*0.5)
  #     diagonal_axis = normalize(center - cube_corner)
  #     by = 22.5
  #     new(around: diagonal_axis, at: center, by: by)
  #   end
  #
  #   def self.build_zero
  #     new(around: 0, at: 0, by: 0)
  #   end
  # end
end
