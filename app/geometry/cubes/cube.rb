class Cube
  attr_reader :faces, :mutable, :initial, :corner

  def initialize(initial:, mutable:, faces:, corner:)
    @initial, @mutable, @faces = initial, mutable, faces
    @corner = corner
  end

  def reset!
    @mutable.points.each.with_index do |p, i|
      p.assign(@initial.points[i])
    end
    self
  end

  def rotate(**kwargs)
    @mutable.rotate!(**kwargs)
  end

  def points
    @mutable.points
  end

  def point_set
    @mutable
  end

  def occluded_faces
    current_nearest_corner = nearest_corner
    faces.reject { |f| f.points.find(current_nearest_corner) }
  end

  def visible_faces
    current_nearest_corner = nearest_corner
    faces.select { |f| f.points.find(current_nearest_corner) }
  end

  def nearest_corner
    @mutable.max_by { |p| p.z }
  end
end