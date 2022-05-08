class App
  include MatrixFunctions

  def perform_tick args
    point_set_renderer.render(cube)
    cube.points.each { |p| puts p }
    # args.gtk.request_quit if args.state.tick_count > 1
  end

  def cube
    @cube ||= Cube.build_simple(vec3(400,400,0), 200)
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