class App
  include MatrixFunctions

  LINE_ORDER = {
    line: 0,
    solid: 1,
  }

  def perform_tick args
    # puts $gtk.args.state.z_primitives
    $render_buffer = []
    # $gtk.args.state.z_primitives = []
    rotate_cube!
    cube.
      farthest_cubies_first.
      map(&:faces).
    #   map do |cubie|
    #   [
    #     *cubie.occluded_faces.zip([true, true, true]),
    #     *cubie.visible_faces.zip([true, true, true])
    #   ]
    # end.
      flatten(1).
      each { |polygon_pointset| PolygonRenderer.new(polygon_pointset).render }
      # each { |polygon_pointset, with_edges| PolygonRenderer.new(polygon_pointset).render(with_edges) }
    perform_rendering
    # cube.cubies.map(&:nearest_corner).first(27)
    #     .map { |np| point_renderer.render(np) }

    # args.gtk.request_quit if args.state.tick_count > 1
  end

  def perform_rendering
    $gtk.args.outputs.primitives << $render_buffer
      # sort do |zta, ztb|
      # ztb.z <=> zta.z
      # end
      # $gtk.
      # args.
      # state.
      # z_primitives.
      # sort_by { |p| p.z }
      # zcomp = (ztb.z <=> zta.z)
      # if zcomp == 0
      #   LINE_ORDER[ztb.primitive_marker] <=> LINE_ORDER[zta.primitive_marker]
      # end
      #
      # zcomp
    # end
  end

  def cube
    @cube ||= Rubiks::Factory.new(cube_corner, cube_size).build
  end

  def rotate_cube!
    cube.reset!
    cube.rotate(
      around: rotation_axis,
      at: cube_center,
      by: rotation_angle,
    )
  end

  def rotation_angle
    (($gtk.args.state.tick_count/12.0) % 180) + 180
    # (($gtk.args.state.tick_count * 5) % 360)
  end

  def rotation_axis
    normalize(add(cube_center, (cube_corner * -1)))
  end

  def rotation_point
    cube_center
  end

  def cube_size
    200
  end

  def cube_corner
    vec3(400,400,0)
  end

  def cube_center
    cube_corner + vec3(cube_size/2, cube_size/2, cube_size/2)
  end

  def point_set_renderer
    @point_set_renderer ||= PointSetRenderer.new(point_renderer: point_renderer)
  end

  def point_renderer
    @point_renderer = PointRenderer.new(sprite_asset: point_sprite_asset)
  end

  def point_sprite_asset
    @point_sprite_asset = SpriteAsset.new(path: 'sprites/star.png', w: 16, h: 16)
  end
end