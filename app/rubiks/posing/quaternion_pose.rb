module Posing
  class QuaternionPose
    attr_accessor :at, :quaternion, :around, :by, :done
    def initialize(quaternion:, by:, around:, at: nil)
      @at = at
      @by = by
      @around = around
      @quaternion = quaternion
    end

    def self.build(at:, around:, by: 0.0)
      q = Quaternion.from_vector(around: around, by: by.to_f)
      new(quaternion: q, at: at, by: by.to_f, around: around)
    end

    def calculate_quaternion
      Quaternion.from_vector(around: around, by: by)
    end

    def by=(new_angle)
      @by = new_angle
      @quaternion.assign!(*(Quaternion.from_vector(around: around, by: by).components))
      self
    end

    def *(other)
      self.class.new(
        quaternion: quaternion * other.quaternion,
        at: other.at,
        around: other.around,
        by: other.by
      )
    end

    def rotation_args
      {quaternion: quaternion, at: at}
    end
  end
end