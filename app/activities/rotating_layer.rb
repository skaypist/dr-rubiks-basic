module RotatingLayer
  class Activity
    include MatrixFunctions

    CENTER_COORDINATES = [300, 300, 300]
    CUBE_SIZE = 120

    def perform_tick
      rotate_layer! unless rotation_paused?
      load_cube_primitives
    end

    def cube
      return @cube if @cube
      @cube = rubiks_cube_factory.build
      rotate_cube!
      @cube
    end

    def rotate_cube!
      @cube.rotate(
        around: rotation_axis,
        at: cube_center,
        by: 22.5,
      )
    end

    def rubiks_cube_factory
      @_rubiks_cube_factory ||= Rubiks::Factory.new(cube_corner, cube_size)
    end

    def rotate_layer!
      layer(5).each do |cubie|
        cubie.reset!
        cubie.rotate(
          around: layer_axis,
          at: cube_center,
          by: rotation_angle,
        )
        cubie.rotate(
          around: rotation_axis,
          at: cube_center,
          by: 22.5,
        )
      end
    end

    def layer_axis
      normalize(vec3(0, 180, 0))
    end

    def layer(i)
      layer_factory.get_layer(i)
    end

    def layer_factory
      @_layer ||= Rubiks::LayerFactory.new(
        cube,
        rubiks_cube_factory.bases,
        cube_corner
      )
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
      layer(5).sort_by {|c| c.nearest_corner.z }.
        each { |cubie| CubieRenderer.render(cubie) }

      (cube.farthest_cubies_first - layer(5)).
        each { |cubie| CubieRenderer.render(cubie) }
    end

    def rotation_angle
      $gtk.args.state.tick_count % 360
    end

    def rotation_axis
      normalize(add(cube_center, (cube_corner * -1)))
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