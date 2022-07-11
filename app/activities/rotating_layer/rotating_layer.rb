module RotatingLayer
  class Activity
    include MatrixFunctions

    def perform_tick
      cube_poser.apply_pose!
      layer_poser&.apply_pose!
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
        turn_direction = calculate_turn_direction(turn_layer, start_cubie, end_cubie)
        begin_turning!(turn_layer, turn_direction)
      end
    end

    def calculate_turn_direction(turn_layer, start_cubie, end_cubie)
      ray1 = normalize(start_cubie.center - turn_layer.center_cubie.center)
      ray2 = normalize(end_cubie.center - turn_layer.center_cubie.center)
      perp = normalize(cross(ray1, ray2))
      dot(perp, turn_layer.axis).round
    end

    def begin_turning!(turn_layer, turn_direction)
      @layer_poser = Posing::LayerPoser.new(turn_layer, turn_direction)
    end

    def on_cube?(drag)
      big_cubie.nearest_faces.find { |bcf| bcf.contains?(vec2(drag.x, drag.y)) }
    end

    def load_cube_primitives
      if layer_poser.actively_posed?
        cube.layers.
          by_characteristic(layer_poser.layer.cubie_characteristic.key).
          each do |layer|
          layer.farthest_cubies_first.
            each { |cubie| CubieRenderer.render(cubie) }
        end
      else
        cube.farthest_cubies_first.
          each { |cubie| CubieRenderer.render(cubie) }
      end
    end

    def cube
      @cube ||= rubiks_cube_factory.build
    end

    def big_cubie
      cube.big_cubie
    end

    def rubiks_cube_factory
      @_rubiks_cube_factory ||= Rubiks::Factory.new
    end

    def layer_poser
      @layer_poser ||= Posing::LayerPoser.new
    end

    def actively_posed_layer_cubies
      layer_poser.layer || []
    end

    def cube_poser
      @cube_poser ||= Posing::CubePoser.new(cube)
    end

    def rotate_drag!(draggy)
      cube_poser.rotate_drag(draggy)
    end

    def collapse_pose!
      cube_poser.collapse_pose!
    end
  end
end