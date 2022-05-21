class App
  include MatrixFunctions

  LINE_ORDER = {
    line: 0,
    solid: 1,
  }

  def perform_tick args
    # puts $gtk.args.state.z_primitives
    $gtk.args.state.z_primitives = []
    rotate_cube
    cube.faces.each { |polygon_pointset| PolygonRenderer.new(polygon_pointset).render }
    perform_rendering
    # args.gtk.request_quit if args.state.tick_count > 1
  end

  def perform_rendering
    $gtk.args.outputs.primitives << $gtk.
      args.
      state.
      z_primitives.
      sort do |zta, ztb|
      zcomp = (ztb.z <=> zta.z)
      if zcomp == 0
        LINE_ORDER[ztb.primitive_marker] <=> LINE_ORDER[zta.primitive_marker]
      end

      zcomp
    end
  end

  def cube
    # @cube ||= Cube.build_simple(cube_corner, cube_size)
    @cube ||= Cube.new(cube_corner, cube_size)
  end

  def rotate_cube
    cube.rotate(
      around: rotation_axis,
      at: cube_center,
      by: 1,
    )
  end

  def rotation_angle
    $gtk.args.state.tick_count % 360
  end

  def rotation_axis
    normalize(add(cube_center, Transforms.scale3(cube_corner, -1)))
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