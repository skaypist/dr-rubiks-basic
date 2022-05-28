class AboutVector < (Minitest::Test)
  include MatrixFunctions

  def test_basic
    v3 = vec3(1,2,3)
    assert_equal(v3.x, 1)
    assert_equal(v3.y, 2)
    assert_equal(v3.z, 3)
  end

  def test_mutable
    v3 = vec3(1,2,3)
    v3.x = 2
    assert_equal(v3.x, 2)
    assert_equal(v3.y, 2)
    assert_equal(v3.z, 3)
    # it's mutable
  end

  def test_equality
    v3 = vec3(1,2,3)
    v3a = vec3(1,2,3)
    assert_equal(v3, v3a)
  end

  def test_marker
    v1 = vec3(1,2,3)
    assert_equal(v1.class, Vec3)
  end

  def test_vector_addition
    v1 = vec3(1,2,3)
    v2 = vec3(3,2,1)
    v3 = v1 + v2
    assert_equal(v3.x, 4)
    assert_equal(v3.y, 4)
    assert_equal(v3.z, 4)
  end

  def test_multiply_identity
    v1 = vec3(1,2,3)
    m1 = mat3(1,0,0,
              0,1,0,
              0,0,1)
    v2 = mul(v1, m1)
    assert_equal(v2.x, 1)
    assert_equal(v2.y, 2)
    assert_equal(v2.z, 3)
  end

  # works after prepending VectorOps
  #

  def test_vector_subtraction
    v1 = vec3(1,2,3)
    v2 = vec3(3,2,1)
    v3 = v1 - v2
    assert_equal(v3.x, -2)
    assert_equal(v3.y, 0)
    assert_equal(v3.z, 2)
  end

  def test_destructive_subtraction
    v1 = vec3(1,2,3)
    v2 = vec3(3,2,1)
    v1 -= v2
    assert_equal(v1.x, -2)
    assert_equal(v1.y, 0)
    assert_equal(v1.z, 2)
  end


  def test_destructive_addition
    v1 = vec3(1,2,3)
    v2 = vec3(3,2,1)
    v1 += v2
    assert_equal(v1.x, 4)
    assert_equal(v1.y, 4)
    assert_equal(v1.z, 4)
  end

  def test_multiply_constant
    v1 = vec3(1,2,3)
    c1 = 3
    v2 = v1 * c1
    assert_equal(v2.x, 3)
    assert_equal(v2.y, 6)
    assert_equal(v2.z, 9)
  end

  def test_destructive_muliply
    v1 = vec3(1,2,3)
    v1 *= 3
    assert_equal(v1.x, 3)
    assert_equal(v1.y, 6)
    assert_equal(v1.z, 9)
  end
end