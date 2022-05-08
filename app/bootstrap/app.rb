class App
  include MatrixFunctions

  def perform_tick args
    point_set_renderer.render(cube)
    # args.gtk.request_quit if args.state.tick_count > 1
  end

  def cube
    # @cube ||= Cube.build_simple(cube_corner, cube_size)
    Cube.build_simple(cube_corner, cube_size).transform(rotation_matrix)
  end

  def rotation_matrix
    rotation_axis = normalize(add(cube_center, Transforms.scale3(cube_corner, -1)))
    Transforms.rotate(around: rotation_axis, angle: $gtk.args.state.tick_count % 360)
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