class Poser
  attr_reader :cube

  def initialize(cube)
    @cube = cube
  end

  def self.prepare(cube)
    @@instance = new(cube)
  end

  def self.instance
    @@instance
  end

  def pose!
    pose_layer!
    pose_cube!
  end

  def pose_cube!
    t = cube.transform
    dont_reset = cube.layers.actively_posed&.to_a
    (cube.cubies - dont_reset).each do |cubie|
      cubie.reset!
      cubie.rotate(around: t.around, at: t.at, by: t.by)
    end

    dont_reset.each do |cubie|
      cubie.rotate(around: t.around, at: t.at, by: t.by)
    end
  end

  def pose_layer!
    return unless cube.layers.actively_posed.any?
    layer = cube.layers.actively_posed
    t = layer.transform
    by_abs = t.by.abs
    if by_abs == 90
      layer.swap_stickers((t.by / t.by.abs).round)
      cube.layers.actively_posed = []
      t.by = 0
    else
      layer.each do |cubie|
        cubie.reset!
        cubie.rotate(around: t.around, at: t.at, by: t.by)
      end
    end
  end
end

class Pose
  attr_accessor :around, :at, :by

  def initialize(around:, at:, by:)
    @around, @at, @by = around, at, by
  end

  def self.build_initial(bases, cube_corner)
    center = (cube_corner + bases.reduce(&:+)*0.5)
    diagonal_axis = normalize(center - cube_corner)
    by = 22.5
    new(around: diagonal_axis, at: center, by: by)
  end
end