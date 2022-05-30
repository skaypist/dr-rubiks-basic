class Polygon < PointSet
  attr_reader :shared

  def initialize(*points)
    @points = points
  end

  def calculate_shared
    self.class.calculate_shared(@points)
  end

  def self.calculate_shared(potential_face_points)
    first, *rest = *potential_face_points
    values_by_dims = {}
    %i[x y z].each do |dim|
      matching = rest.all? { |p| p[dim] == first[dim] }
      values_by_dims[dim] = first[dim] if matching
    end
    values_by_dims.values
  end
end