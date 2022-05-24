class Cube
  extend MatrixFunctions
  include MatrixFunctions
  include VectorHelpers

  attr_reader :corner, :size, :faces

  def initialize(corner, size)
    @corner, @size = corner, size
    @canonical_cube_points = PointSet.new(*calculate_cube_points)
    @mutable_point_set = MutablePointSet.from_points(*(@canonical_cube_points.points))
    @faces = calculate_face_point_sets
  end

  def reset!
    @mutable_point_set.mutable_points.each.with_index do |mp, i|
      mp.set @canonical_cube_points.points[i]
    end
  end

  def bases
    @bases ||= [
      vec3(size,0,0),
      vec3(0,size,0),
      vec3(0,0,size)
    ]
  end

  def points
    @mutable_point_set.points
  end

  def point_set
    @mutable_point_set
  end

  #
  # def self.coordinates(v3)
  #   [v3.x, v3.y, v3.z]
  # end
  #
  # def self.mag2(v3)
  #   coordinates(v3).map {|c| c*c }.sum
  # end
  #
  # def mag2(v3)
  #   self.class.mag2(v3)
  # end

  private

  def calculate_cube_points
    [0, 1, 2, 3].map do |dim_count|
      combos = bases.combination(dim_count).to_a
      combos.map do |combo|
        if combo.any?
          sum =combo.reduce do |base, bi|
            add(base, bi)
          end

          add(corner, sum)
        else
          [corner]
        end
      end
    end.flatten
  end

  def calculate_face_point_sets
    @mutable_point_set
      .mutable_points
      .combination(4)
      .to_a
      .keep_if do |potential_face_points|
      matching_xs = (potential_face_points.map { |p| p.value.x }.uniq.count == 1)
      matching_ys = (potential_face_points.map { |p| p.value.y }.uniq.count == 1)
      matching_zs = (potential_face_points.map { |p| p.value.z }.uniq.count == 1)
      (matching_xs || matching_ys || matching_zs)
    end.map do |face_points|
      fps = face_points.sort_by { |fp| mag2(fp.value) }
      MutablePointSet.new(fps[0], fps[1], fps[3], fps[2])
    end
  end
end
