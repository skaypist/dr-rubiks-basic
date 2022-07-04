module Posing
  module Rotatable
    def rotate!(quaternion)
      mat = quaternion.rotation_matrix
      cubies.flat_map(&:points).each do |point|
        point.assign(
          (point.translate(center * -1) * mat).
            translate(center)
        )
      end
    end

    def build_inert_pose
      QuaternionPose.build(at: center, around: axis)
    end
  end
end