class AboutPointSet < (Minitest::Test)
  include MatrixFunctions

  def test_create
    v1 = vec3(1,2,3)
    v2 = vec3(1,2,3)
    ps = PointSet.new(v1, v2)
    assert_equal(ps.points.count, 2)
  end

  def test_concat
    v1 = vec3(1,2,3)
    v2 = vec3(3,2,1)
    v3 = vec3(0,0,1)
    ps1 = PointSet.new(v1, v2)
    ps2 = ps1.concat(v3)
    assert_equal(ps2.points.count, 3)
  end

  def test_equality
    v1 = vec3(1,2,3)
    v2 = vec3(3,2,1)
    v1a = vec3(1,2,3)
    v2a = vec3(1,2,3)

    ps1 = PointSet.new(v1, v2)
    ps2 = ps1.concat(v1a, v2a)
    assert_equal(ps1, ps2)
  end

  def test_translate
    v1 = vec3(1,2,3)
    v2 = vec3(3,2,1)
    v3 = vec3(0,0,1)
    ps1 = PointSet.new(v1, v2)
    ps2 = ps1.translate(v3)
    assert(ps2.find(vec3(1,2,4)))
    assert(ps2.find(vec3(3,2,2)))
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