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

  def rotate!(**kwargs)
    each do |p|
      p.rotate!(**kwargs)
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