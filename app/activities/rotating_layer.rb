module RotatingLayer
  class Activity
    include MatrixFunctions

    CENTER_COORDINATES = [240, 240, 240]
    CUBE_SIZE = 120

    def perform_tick
      # rotate_layer! unless rotation_paused?
      # rotate_cube! unless rotation_paused?
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
      @poser ||= Poser.new(cube, big_cubie)
    end

    def big_cubie
      @big_cubie ||= rubiks_cube_factory.big_cubie
    end

    def collapse_pose!
      poser.collapse_pose!
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
      # puts @cached_on_cube.inspect
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
        # puts "incomplete"
        # puts "drag_face_char:"
        # puts drag_face_char
        # puts "start: #{!!start_cubie} | end: #{!!end_cubie} | separate: #{start_cubie != end_cubie}"
        return nil
      end

      turn_layer = cube.layers.by_cubies_and_face(
        cubies: [start_cubie, end_cubie],
        edge_face_char: drag_face_char
      )

      @cached_on_cube = nil
      if !turn_layer.nil? && !turn_layer.none?
        # start_cubie.faces.each { |face| puts face.inspect && face.color.darken!(0.8)}
        # end_cubie.faces.each { |face| face.color.darken!(0.8)}
        # puts "start_cubie #{start_cubie.inspect}"
        # puts "end_cubie #{end_cubie.inspect}"
        puts "turny_layer found: that layer's center cubie characteristic"
        puts turn_layer.cubie_characteristic.inspect
      else
        puts "no turny layer found"
      end
      turn_layer
    end

    # def turn!(drag)
    #   return unless @cached_on_cube
    #   char = @cached_on_cube.characteristic
    #   drag_start = vec2(drag.x, drag.y)
    #   puts char
    #   start_pseudo_layer = outside_visible_cubies
    #     .select { |cubie| cubie.face_characteristics.find { |fc| fc.id == char.id} }
    #   puts "has #{start_pseudo_layer.count} cubies "
    #   puts "pseudo layer colors:"
    #   puts start_pseudo_layer.
    #     flat_map { |cubie| cubie.outside_faces.flat_map { |f| f.color.name} }.
    #     group_by { |v| v }.
    #     sort_by { |_k, v| -v.count }.
    #     map { |_k, v| v }.
    #     first.
    #     uniq
    #   start_cubie = start_pseudo_layer.find do |cubie|
    #     cubie.faces.
    #       find { |face| face.characteristic == char }.
    #       tap { |found_face| puts found_face.inspect }.
    #       contains?(drag_start)
    #   end
    #
    #   drag_end = vec2(drag.x2, drag.y2)
    #   end_cubie = start_pseudo_layer.find do |cubie|
    #     next if cubie == start_cubie
    #     cubie.faces.
    #       find { |face| face.characteristic == char }.
    #       tap { |found_face| puts found_face.inspect }.
    #       contains?(drag_end)
    #   end
    #
    #   puts "start_cubie"
    #   puts start_cubie.inspect
    #   puts "end_cubie"
    #   puts end_cubie.inspect
    #   puts "checking characteristics"
    #   puts start_cubie.face_characteristics
    #   puts start_cubie.face_characteristics & end_cubie.face_characteristics
    #   rotation_layer = (start_cubie.face_characteristics & end_cubie.face_characteristics) - [char]
    #   puts "rotation_layer"
    #   puts rotation_layer
    #   puts "-----------------"
    #
    #   @cached_on_cube = nil
    # end
    #
    # def outside_visible_cubies
    #   characteristics_for_visible_faces = cube.nearest_cubie.face_characteristics
    #   puts "characteristics_for_visible_faces"
    #   puts characteristics_for_visible_faces
    #   characteristics_for_visible_faces.flat_map do |char|
    #     cube.cubies.select do |cubie|
    #       cubie.face_characteristics.find { |fc| fc.id == char.id  }
    #     end
    #   end.uniq
    # end

    def on_cube?(drag)
      # puts "visible cube faces"
      # puts cube_faces.cubie.visible_faces.map(&:characteristic)
      # puts "#on_cube?"
      # puts "  nearest corner of the cube"
      # puts "  #{big_cubie.nearest_corner.round.inspect}"
      touching = big_cubie.visible_faces.find { |bcf| bcf.contains?(vec2(drag.x, drag.y)) }
      # if touching
      #   puts "touching outside "
      #   puts touching.color.name
      # end
      touching
    end

    def rotate_drag!(draggy)
      around = vec3(
        # CUBE_SIZE*1.5*Math.acos(draggy[:x2] - draggy[:x]),
        draggy.y - draggy.y2,
        draggy.x2 - draggy.x,
        # CUBE_SIZE*1.5*Math.acos(draggy[:y2] - draggy[:y])
        0
      )

      cube.second_transform = QuaternionPose.new(
        quaternion: Quaternion.from_vector(
          around: normalize(around),
          by: around.mag2 / (3*CUBE_SIZE)
        ),
        at: cube_center,
      )
    end

    def rotate_cube!
      cube.transforms.first.by = cube.transforms.first.by + 3
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
      # CubieRenderer.render(big_cubie)
    end

    def cube_center
      (cube_corner + vec3(cube_size/2, cube_size/2, cube_size/2))
    end

    def cube_size
      CUBE_SIZE
    end

    def cube_corner
      vec3(*CENTER_COORDINATES)
    end
  end
end