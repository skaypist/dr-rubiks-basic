class AboutBasic < (Minitest::Test)
  include MatrixFunctions

  def test_basic
    v3 = vec3(1,2,3)
    assert_equal(v3.x, 1)
    assert_equal(v3.y, 2)
    assert_equal(v3.z, 3)
  end
end