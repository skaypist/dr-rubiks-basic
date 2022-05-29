class PointSet
  include MatrixFunctions
  include Enumerable

  attr_reader :points

  def initialize(*points)
    @points = points
  end

  def each
    @points.each { |p| yield p } if block_given?
    @points.each
  end

  def rotate!(around:, at:, by:)
    each do |p|
      p.rotate!(around: around, at: at, by: by)
    end
  end

  def ==(point_set)
    (points - point_set.points).empty? &&
      (point_set.points - points).empty?
  end

  def inspect
    points.inspect
  end
end