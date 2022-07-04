module RotatingLayer
  class Activity
    include MatrixFunctions

    CENTER_COORDINATES = [240, 240, 240]
    CUBE_SIZE = 120

    def perform_tick
      # rotate_layer! unless rotation_paused?
      # rotate_cube! unless rotation_paused?
      poser.pose!
      cube_poser.apply_pose!
      load_cube_primitives
    end

    def drag!(draggy)
      @cached_on_cube ||= nil
      return if swipe_layer!(draggy)
      rotate_drag!(draggy)
    end

    def swipe_layer!(drag)
      if !@drag_digest.nil? && @drag_digest == drag.digest
        return @cached_on_cube
      else
        @drag_digest = drag.digest
      end
      @cached_on_cube = on_cube?(drag)
      return @cached_on_cube
    end

    def turn!(drag)
      return unless @cached_on_cube
      drag_face_char = @cached_on_cube.characteristic
      drag_layer = cube.layers.by_outside_face_char(drag_face_char)

      drag_start = vec2(drag.x, drag.y)
      start_cubie = drag_layer.by_coordinates(drag_start, drag_face_char)

      drag_end = vec2(drag.x2, drag.y2)
      end_cubie = drag_layer.by_coordinates(drag_end, drag_face_char)

      unless start_cubie && end_cubie && start_cubie != end_cubie
        @cached_on_cube = nil
        return nil
      end

      turn_layer = cube.layers.by_cubies_and_face(
        cubies: [start_cubie, end_cubie],
        edge_face_char: drag_face_char
      )

      @cached_on_cube = nil
      if !turn_layer.nil? && !turn_layer.none?
        puts "turny_layer found: that layer's center cubie characteristic"
        puts turn_layer.cubie_characteristic.inspect
      else
        puts "no turny layer found"
      end
      turn_layer
    end

    def on_cube?(drag)
      big_cubie.visible_faces.find { |bcf| bcf.contains?(vec2(drag.x, drag.y)) }
    end

    def rotate_drag!(draggy)
      cube_poser.rotate_drag(draggy)
    end

    def collapse_pose!
      cube_poser.collapse_pose!
    end

    # def rotate_drag!(draggy)
    #   around = vec3(
    #     draggy.y - draggy.y2,
    #     draggy.x2 - draggy.x,
    #     0
    #   )
    #
    #   cube.second_transform = Posing::QuaternionPose.build(
    #     around: normalize(around),
    #     by: around.mag2 / (3*Config.block_size),
    #     at: Config.center,
    #   )
    # end

    def load_cube_primitives
      cube.layers.actively_posed.sort_by {|c| c.nearest_corner.z }.
        each { |cubie| CubieRenderer.render(cubie) }

      (cube.farthest_cubies_first - cube.layers.actively_posed.to_a).
        each { |cubie| CubieRenderer.render(cubie) }
    end

    def cube
      @cube ||= rubiks_cube_factory.build
    end

    def rubiks_cube_factory
      @_rubiks_cube_factory ||= Rubiks::Factory.new
    end

    def poser
      @poser ||= Posing::Poser.new(cube, big_cubie)
    end

    def cube_poser
      @cube_poser ||= Posing::CubePoser.new(cube, big_cubie)
    end

    def big_cubie
      @big_cubie ||= rubiks_cube_factory.big_cubie
    end
  end
end