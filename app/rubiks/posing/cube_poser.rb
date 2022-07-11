module Posing
  class CubePoser
    include MatrixFunctions

    def initialize(cube)
      @cube = cube
    end

    def rotate_drag(draggy)
      around = vec3(
        draggy.y - draggy.y2,
        draggy.x2 - draggy.x,
        0
      )

      by = around.mag2 / (3*Rubiks::Config.block_size)

      quaternion = Quaternion.
        from_vector(around: around, by: by.to_f)
      @floating_q = quaternion
    end

    def combined_q
      floating_q * reference_q
    end

    def floating_q
      @floating_q ||= Quaternion.new(1, 0, 0, 0)
    end

    def collapse_pose!
      @reference_q = combined_q
      @floating_q = nil
    end

    def apply_pose!
      poseables.each do |poseable|
        poseable.reset!
        poseable.rotate!(combined_q)
      end
    end

    def poseables
      @poseables ||= [@cube, big_cubie]
    end

    def big_cubie
      @big_cubie ||= @cube.big_cubie
    end

    def reference_q
      @reference_q ||= initial_pose
    end

    def initial_pose
      diagonal_axis = normalize(Rubiks::Config.center - Rubiks::Config.center_corner)
      Quaternion.from_vector(around: diagonal_axis, by: 22.5)
    end
  end
end