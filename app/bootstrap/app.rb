class App
  include MatrixFunctions

  def perform_tick args
    $render_buffer = []
    rotate_cube!
    cube.
      farthest_cubies_first.
      map(&:faces).
      flatten(1).
      each { |polygon_pointset| PolygonRenderer.new(polygon_pointset).render }
    perform_rendering
  end

  def perform_rendering
    $gtk.args.outputs.primitives << $render_buffer
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
    (($gtk.args.state.tick_count*2) % 180) + 180
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