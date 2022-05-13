class PolygonSet
  attr_reader :polygons

  def initialize(*polygons)
    @polygons = polygons
  end

  # hmm
  def rotate(**kwargs)
    new_polygons = @polygons.map do |p|
      p.rotate(**kwargs)
    end

    PolygonSet.new(*new_polygons)
  end
end