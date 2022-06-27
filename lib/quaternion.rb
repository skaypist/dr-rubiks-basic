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

  def initialize(*dim_args)
    assign!(*dim_args)
  end

  def assign!(*comps)
    @w, @x, @y, @z = *comps
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

  def inverse
    self.class.new(w, x*-1.0, y*-1.0, z*-1.0) * (1.0 / mag2)
  end

  def norm
    Math.sqrt(mag2)
  end

  def mag2
    vec4(*components).mag2
  end

  def *(other)
    if other.is_a?(Numeric)
      self.class.new(*components.map {|c| c*other })
    elsif other.is_a?(Quaternion)
      a1, b1, c1, d1 = *components
      a2, b2, c2, d2 = *other.components

      a3 = a1*a2 - b1*b2 - c1*c2 - d1*d2
      b3 = a1*b2 + b1*a2 + c1*d2 - d1*c2
      c3 = a1*c2 - b1*d2 + c1*a2 + d1*b2
      d3 = a1*d2 + b1*c2 - c1*b2 + d1*a2
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