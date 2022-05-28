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

  def rotate(around:, at:, by:)
    rotation_matrix = Transforms.rotate(
      around: around,
      angle: by
    )

    translate(Transforms.scale3(at, -1)).
      transform(rotation_matrix).
      translate(at)
  end

  def ==(point_set)
    (points - point_set.points).empty? &&
      (point_set.points - points).empty?
  end

  def find(a)
    points.find(a)
  end

  def inspect
    points.map { |p| p.inspect }.join(' ')
  end

  def to_s
    inspect
  end
end

class MutablePointSet
  include MatrixFunctions

  attr_reader :mutable_points

  def self.from_points(*ps)
    new(*(ps.map { |p| Mutable.new(p) }))
  end

  def initialize(*mutable_points)
    @mutable_points = mutable_points
  end

  def points
    @mutable_points.map(&:value)
  end

  def map!
    mutable_points.each.with_index do |p, i|
      p.set(yield p.value, i)
    end
    self
  end

  def translate(vector)
    map! { |p| p + vector }
  end

  def scale(constant)
    map! { |p| Transforms.scale3(p, constant) }
  end

  def transform(mat)
    map! { |p| mul(p, mat) }
  end

  def rotate(around:, at:, by:)
    rotation_matrix = Transforms.rotate(
      around: normalize(around),
      angle: by
    )

    translate(Transforms.scale3(at, -1)).
      transform(rotation_matrix).
      translate(at)
  end

  def ==(point_set)
    (points - point_set.points).empty? &&
      (point_set.points - points).empty?
  end

  def find(a)
    points.find(a)
  end

  def inspect
    points.map { |p| p.inspect }.join(' ')
  end

  def to_s
    inspect
  end
end