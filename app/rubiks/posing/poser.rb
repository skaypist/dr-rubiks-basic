module Posing
  class Poser
    attr_reader :cube, :big_cubie

    def initialize(cube, big_cubie)
      @cube, @big_cubie = cube, big_cubie
    end

    def pose!
      pose_layer!
      pose_cube!
      pose_big_cubie!
    end

    def collapse_pose!
      cube.collapse_pose!
    end

    def pose_big_cubie!
      t = cube.transforms.first
      t2 = cube.transforms.second
      big_cubie.reset!
      big_cubie.rotate(quaternion: t.quaternion, at: t.at)
      big_cubie.rotate(quaternion: t2.quaternion, at: t2.at) if t2
    end

    def pose_cube!
      dont_reset = cube.layers.actively_posed&.to_a

      t = cube.transforms.first
      t2 = cube.transforms.second

      (cube.cubies - dont_reset).each do |cubie|
        cubie.reset!
        # cubie.rotate(around: t.around, at: t.at, by: t.by)
        # cubie.rotate(around: t2.around, at: t2.at, by: t2.by) if t2
        cubie.rotate(quaternion: t.quaternion, at: t.at)
        cubie.rotate(quaternion: t2.quaternion, at: t2.at) if t2
      end

      dont_reset.each do |cubie|
        # cubie.rotate(around: t.around, at: t.at, by: t.by)
        # cubie.rotate(around: t2.around, at: t2.at, by: t2.by) if t2
        cubie.rotate(quaternion: t.quaternion, at: t.at)
        cubie.rotate(quaternion: t2.quaternion, at: t2.at) if t2
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
end