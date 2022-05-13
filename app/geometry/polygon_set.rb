class PolygonSet
  attr_reader :polygons

  def initialize(*polygons)
    @polygons = polygons
  end

  # hmm
  def rotate(**kwargs)
    @polygons = @polygons.map do |p|
      p.rotate(**kwargs)
    end
    self
  end
end