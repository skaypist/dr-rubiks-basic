DEGREES_TO_RADIANS = Math::PI / 180

class Transforms
  extend MatrixFunctions

  def self.rotate(around:, angle:)
    # points.each do |point|
      # dot(point, around) * around * (1 - Math.cos(angle)) +
      #   Math.cos(angle) * point +
      #   Math.sin(angle) * cross(around, point)
    u_x = around.x
    u_y = around.y
    u_z = around.z

    c = Math.cos(angle * DEGREES_TO_RADIANS)
    s = Math.sin(angle * DEGREES_TO_RADIANS)
    t = 1.0 - c

    mat3(t*u_x*u_x+c, t*u_x*u_y - s*u_z, t*u_x*u_z + s*u_y,
         t*u_x*u_y + s*u_z, t*u_y*u_y+c, t*u_y*u_z - s*u_y,
         t*u_x*u_z - s*u_y, t*u_y*u_z + c*u_x, t*u_z*u_z+c)
    # end
  end

  def self.scale3(vec, by)
    vec3(vec.x*by, vec.y*by, vec.z*by)
  end
end