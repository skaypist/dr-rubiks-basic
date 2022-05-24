class Mutable
  attr_reader :keep

  def initialize(keep)
    @keep = keep
  end

  def update
    @keep = yield keep
  end

  def set(new_val)
    @keep = new_val
  end

  def value
    @keep
  end
end