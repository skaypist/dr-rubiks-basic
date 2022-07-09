module Posing
  module Rotatable
    def rotate!(quaternion)
      mat = quaternion.rotation_matrix
      current_center = center


      (cubies.to_a - [center_cubie].compact).flat_map(&:points).each do |point|
        point.assign(
          (point.translate(current_center * -1) * mat).
            translate(current_center)
        )
      end

      [center_cubie].compact.flat_map(&:points).each do |point|
        point.assign(
          (point.translate(current_center * -1) * mat).
            translate(current_center)
        )
      end
    end
  end
end