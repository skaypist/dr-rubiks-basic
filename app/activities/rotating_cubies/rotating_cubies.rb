module RotatingCubies
  class Activity
    include MatrixFunctions

    CENTER_COORDINATES = [300, 300, 0]
    CUBE_SIZE = 150

    def perform_tick
      rotate_cube!
      load_cube_primitives
    end

    def cube
      @cube ||= Rubiks::Factory.new.build
    end

    def rotate_cube!
      cube.reset!
      cube.rotate(
        around: rotation_axis,
        at: cube_center,
        by: rotation_angle,
        )
    end

    def num_cubies_shown
      @_num_cubies_shown ||= 0
    end

    def add_cubie!
      @_num_cubies_shown = num_cubies_shown + 1 unless num_cubies_shown == 27
    end
    #
    # def load_cube_primitives
    #   cube.
    #     farthest_cubies_first.
    #     map(&:visible_faces).
    #     flatten(1).
    #     each { |polygon_pointset| PolygonRenderer.new(polygon_pointset).render }
    # end

    def load_cube_primitives
      cube.
        farthest_cubies_first.
        each { |cubie| CubieRenderer.render(cubie) }
    end

    def rotation_angle
      $gtk.args.state.tick_count % 360
    end

    def rotation_axis
      normalize(add(cube_center, (cube_corner * -1)))
    end

    def rotation_point
      cube_center
    end

    def cube_center
      (cube_corner + vec3(cube_size, cube_size, cube_size)*0.5)
    end

    def cube_size
      CUBE_SIZE
    end

    def cube_corner
      vec3(*CENTER_COORDINATES)
    end
  end
end