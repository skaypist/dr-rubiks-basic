include MatrixFunctions

DEGREES_TO_RADIANS = Math::PI / 180

class RotationCache
  include MatrixFunctions

  @@instance = nil

  attr_reader :around, :by

  def self.rotation_matrix(around:, by:)
    instance.rotation_matrix(ask_around: around, ask_by: by)
  end

  def rotation_matrix(ask_around:, ask_by:)
    if around == ask_around && by == ask_by
      @mat
    else
      @around = ask_around
      @by = ask_by
      @mat = calculate_mat
    end
  end


  def calculate_mat
    u_x = around.x
    u_y = around.y
    u_z = around.z

    c = Math.cos(by * DEGREES_TO_RADIANS)
    s = Math.sin(by * DEGREES_TO_RADIANS)
    t = 1.0 - c

    mat3(t*u_x*u_x + c,     t*u_x*u_y - s*u_z, t*u_x*u_z + s*u_y,
         t*u_x*u_y + s*u_z, t*u_y*u_y + c,     t*u_y*u_z - s*u_x,
         t*u_x*u_z - s*u_y, t*u_y*u_z + s*u_x, t*u_z*u_z + c)
  end

  def self.instance
    @@instance ||= new
  end
end

module VectorOps
  def build(*coords)
    send(self.class.name.to_s.downcase, *coords)
  end

  def mag2
    coordinates.map { |c| c**2 }.sum
  end

  def coordinates
    values
  end

  def angle_to(other)
    ns = normalize(self)
    nother = normalize(other)
    Math.acos(dot(ns, nother))
  end

  def -(other)
    add(self,(other * (-1)))
  end

  def *(other)
    case other.class.name
    when *%w[Numeric Float Integer Fixnum]
      new_coords = coordinates
                     .map { |c| c * other }
                     .flatten
      build(*new_coords)
    when *%w[Mat2 Mat3 Mat4]
      mul(self, other)
    else
      super
    end
  end

  def translate(other)
    self + other
  end

  def translate!(other)
    self.send('+='.to_sym, other)
  end

  def rotation_matrix(around:, by:)
    ::RotationCache.rotation_matrix(around: around, by: by)
  end

  def rotate(around:, by:, at:)
    (translate(at * -1)*rotation_matrix(around: around, by: by))
      .translate(at)
  end

  def rotate!(around:, by:, at:)
    assign(rotate(around: around, at: at, by: by))
  end

  def assign(other)
    %i[w x y z].each do |c|
      cv = other.send(c)
      self.send("#{c}=".to_sym, cv) unless cv.nil?
    end
    self
  end

  define_method(:'*=') {|other| assign(self * other)}
  define_method(:'+=') {|other| assign(self + other)}
  define_method(:'-=') {|other| assign(self - other)}
end

[Vec2, Vec3, Vec4].each do |vector_class|
  vector_class.prepend(VectorOps)
end