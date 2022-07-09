include MatrixFunctions

DEGREES_TO_RADIANS = Math::PI / 180

module VectorOps
  def build(*coords)
    send(self.class.name.to_s.downcase, *coords)
  end

  def to_h
    map { |k, v| [k, v]}.to_h
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

  def rotate!(quaternion:, at:)
    qrmat = QuaternionRotationCache.rotation_matrix(quaternion)
    assign(
      (translate(at * -1)*qrmat)
        .translate(at)
    )
  end

  def assign(other)
    %i[w x y z].each do |c|
      cv = other.send(c)
      self.send("#{c}=".to_sym, cv) unless cv.nil?
    end
    self
  end

  def abs
    build(*coordinates.map(&:abs))
  end

  def round
    build(*coordinates.map(&:round))
  end

  define_method(:'*=') {|other| assign(self * other)}
  define_method(:'+=') {|other| assign(self + other)}
  define_method(:'-=') {|other| assign(self - other)}
end

[Vec2, Vec3, Vec4].each do |vector_class|
  vector_class.prepend(VectorOps)
end