module RotatingLayer
  class Activity
    include MatrixFunctions

    CENTER_COORDINATES = [240, 240, 240]
    CUBE_SIZE = 120

    def perform_tick
      rotate_layer! unless rotation_paused?
      rotate_cube! unless rotation_paused?
      poser.pose!
      load_cube_primitives
    end

    def cube
      @cube ||= rubiks_cube_factory.build
    end

    def rubiks_cube_factory
      @_rubiks_cube_factory ||= Rubiks::Factory.new(cube_corner, cube_size)
    end

    def poser
      @poser ||= Poser.new(cube)
    end

    def rotate_cube!
      cube.transform.by = cube.transform.by + 3
    end

    def rotate_layer!
      cube.layers.rotate(5, 3)
    end

    def layer_axis
      normalize(vec3(0, 180, 0))
    end

    def rotation_paused?
      @_rotation_paused ||= false
    end

    def toggle_rotation!
      @_rotation_paused = !rotation_paused?
    end

    def add_cubes!
      @_num_cubes = [num_cubes + 1, 27].min
    end

    def remove_cubes!
      @_num_cubes = [num_cubes - 1, 0].max
    end

    def num_cubes
      @_num_cubes ||= 27
    end

    def load_cube_primitives
      cube.layers.actively_posed.sort_by {|c| c.nearest_corner.z }.
        each { |cubie| CubieRenderer.render(cubie) }

      (cube.farthest_cubies_first - cube.layers.actively_posed.to_a).
        each { |cubie| CubieRenderer.render(cubie) }
    end

    def cube_size
      CUBE_SIZE
    end

    def cube_corner
      vec3(*CENTER_COORDINATES)
    end
  end
end