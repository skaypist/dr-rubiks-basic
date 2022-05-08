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

  def test_addition
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
end