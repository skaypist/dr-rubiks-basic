class Quaternion
  include MatrixFunctions

  def self.from_vector(around:, by:)
    w = Math.cos(by * DEGREES_TO_RADIANS * 0.5)
    around_normalized = normalize(around)
    hsin = Math.sin(by * DEGREES_TO_RADIANS * 0.5)
    x = around_normalized.x *  hsin
    y = around_normalized.y *  hsin
    z = around_normalized.z *  hsin

    new(w, x, y, z)
  end

  attr_reader *%i[w x y z]

  def initialize(w, x, y, z)
    @w, @x, @y, @z = w, x, y, z
  end

  def rotation_matrix
    mat3(
      2*(w**2 + x**2) - 1,       2*x*y - 2*w*z,       2*x*z + 2*w*y,
      2*x*y + 2*w*z,             2*(w**2 + y**2) - 1, 2*y*z - 2*w*x,
      2*x*z - 2*w*y,             2*y*z + 2*w*x,       2*(w**2 + z**2) - 1
    )
  end

  def components
    [w, x, y, z]
  end

  def ==(other)
    components == other&.components
  end

  def norm
    Math.sqrt(vec4(*components).mag2)
  end

  def *(other)
    if other.is_a?(Numeric)
      self.class.new(*components.map {|c| c*other })
    elsif other.is_a?(Quaternion)
      puts components
      puts "norm: #{norm}"
      puts other.components
      puts "other norm: #{other.norm}"
      a1, b1, c1, d1 = *components
      a2, b2, c2, d2 = *other.components

      a3 = a1*a2 - b1*b2 - c1*c2 - d1*d2
      b3 = a1*b2 + b1*a2 + c1*d2 - d1*c2
      c3 = a1*c2 - b1*d2 + c1*a2 + d1*b2
      d3 = a1*d2 + b1*c2 - c1*b2 + d1*a2

      # a1, a2, a3, a4 = *components
      # b1, b2, b3, b4 = *other.components

      # a3 = a1*b1 - a2*b2 - a3*b3 - a4*b4
      # b3 = a1*b2 + a2*b1 + a3*b4 - a4*b3
      # c3 = a1*b3 - a2*b4 + a3*b1 + a4*b2
      # d3 = a1*b4 + a2*b3 - a3*b2 + a4*b1

      # a3 = a1*b1 - a2*b2 - a3*b3 - a4*b4
      # b3 = a1*b2 + a2*b1 + a3*b4 - a4*b3
      # c3 = a1*b3 - a2*b4 + a3*b1 + a4*b2
      # d3 = a1*b4 + a2*b3 - a3*b2 + a4*b1

      uxyz = vec3(b3, c3, d3)
      xyz = normalize(uxyz)
      # self.class.new(vals.x, vals.y, vals.z, vals.w)
      # self.class.new(Math.sqrt((1 - uxyz.mag2).abs), xyz.x, xyz.y, xyz.z)
      self.class.new(a3, b3, c3, d3)
    end
  end
end

class QuaternionRotationCache
  @@instance = nil

  attr_reader :cached_q

  def self.rotation_matrix(q)
    instance.rotation_matrix(q)
  end

  def rotation_matrix(ask_q)
    if cached_q == ask_q
      @mat
    else
      @cached_q = ask_q.clone
      @mat = @cached_q.rotation_matrix
    end
  end

  def self.instance
    @@instance ||= new
  end
end