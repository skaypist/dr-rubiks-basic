module VectorHelpers
  def mag2(linear)
    coordinates(linear).map { |c| c**2 }.sum
  end

  def coordinates(linear)
    linear.values
  end
end