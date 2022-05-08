class SpriteAsset
  attr_reader :path, :w, :h

  def initialize(path:, w:, h:)
    @path, @w, @h = path, w, h
  end
end

class PointRenderer
  def initialize(sprite_asset: )
    @sprite_asset = sprite_asset
  end


  def render(point)
    $gtk.args.outputs.sprites << {
      path: sprite_asset.path,
      w: sprite_asset.w,
      h: sprite_asset.h,
      x: point.x,
      y: point.y,
    }
  end

  private
  attr_reader :sprite_asset
end


class PointSetRenderer
  def initialize(point_renderer:)
    @point_renderer = point_renderer
  end

  def render(point_set)
    point_set.points.map { |p| point_renderer.render(p) }
  end

  private
  attr_reader :point_renderer
end