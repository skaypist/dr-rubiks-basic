class Cube
  include MatrixFunctions
  attr_reader :faces, :mutable, :initial

  def initialize(initial:, mutable:, faces:)
    @initial, @mutable, @faces = initial, mutable, faces
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

  def nearest_corner
    @mutable.max_by { |p| p.z }
  end
end