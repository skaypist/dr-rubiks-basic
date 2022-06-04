class App
  include MatrixFunctions

  def perform_tick _args
    $render_buffer = []
    rotating_cubies_controller.on_tick(_args)
    perform_rendering
  end

  def perform_rendering
    $gtk.args.outputs.primitives << $render_buffer
  end

  def drag_provider
    @drag_provider ||= ::Dragging::DragProvider.instance
  end

  def rotating_cubies_controller
    @rotating_cubies_controller ||= RotatingCubies::Controller.new(
      activity: rotating_cubies_activity,
      drag_provider: drag_provider,
    )
  end

  def rotating_cubies_activity
    @rotating_cubies_activity ||= RotatingCubies::Activity.new
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