class PointSet
  include MatrixFunctions

  attr_reader :points

  def initialize(*points)
    @points = points
  end

  def concat(*more_points)
    PointSet.new(*points.concat(more_points))
  end

  def translate(vector)
    PointSet.new(*points.map { |p| p + vector})
  end

  def scale(constant)
    PointSet.new(*points.map { |p| p * constant})
  end

  def transform(mat)
    PointSet.new(*points.map { |p| mul(p, mat)})
  end

  def ==(point_set)
    (points - point_set.points).empty? &&
      (point_set.points - points).empty?
  end

  def find(a)
    points.find(a)
  end
end