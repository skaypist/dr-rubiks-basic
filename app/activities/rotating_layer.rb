module RotatingLayer
  class Activity
    include MatrixFunctions

    CENTER_COORDINATES = [300, 300, 300]
    CUBE_SIZE = 120

    def perform_tick
      rotate_layer!
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
      @_rubiks_cube_factory = Rubiks::Factory.new(cube_corner, cube_size)
    end

    def rotate_layer!
      # cube.reset!
      layer(5).each do |cubie|
        # puts "#"
        # puts cubie.layer_characteristics
        # puts "#"
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

        # cubie.rotate(
        #   around: rotation_axis,
        #   at: cube_center,
        #   by: 22.5,
        # )
      end

      # puts layer(5).first.layer_characteristics if $gtk.args.state.tick_count  == 1
    end

    def layer_axis
      normalize(vec3(0, 180, 0))
    end

    def layer(i)
      layer_factory.get_layer(i)
    end

    def layer_factory
      # @_layer ||= Rubiks::LayerFactory.new(cube, rubiks_cube_factory.bases, cube_corner)
      return @_layer if @_layer
      @_layer = Rubiks::LayerFactory.new(cube, rubiks_cube_factory.bases, cube_corner)
      # puts "@layer.layer_characteristics"
      # puts @_layer.get_layer(1).count
      # puts "+++++++++++++++++++++++++"
      @_layer
    end

    # def load_cube_primitives
    #   cube.
    #     farthest_cubies_first.
    #     map(&:visible_faces).
    #     flatten(1).
    #     each { |polygon_pointset| PolygonRenderer.new(polygon_pointset).render }
    # end

    def load_cube_primitives
      layer(5).sort_by {|c| c.nearest_corner.z }.
        each { |cubie| CubieRenderer.render(cubie) }

      (cube.cubies - layer(5)).sort_by {|c| c.nearest_corner.z }.
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