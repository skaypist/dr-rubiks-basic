class Cube
  attr_reader :faces

  def initialize(initial:, mutable:, faces:)
    @initial, @mutable, @faces = initial, mutable, faces
  end

  def reset!
    @mutable.map! do |_p, i|
      @initial.points[i]
    end
  end

  def points
    @mutable.points
  end

  def point_set
    @mutable
  end
end