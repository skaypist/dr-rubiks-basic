module Rubiks
  class CharacteristicRegistry
    def initialize
      @registered_ary = []
      @registered_h   = {}
    end

    def self.instance
      @@instance ||= new
    end

    def self.register(value)
      instance.register(value)
    end

    def next_id
      @registered_ary.count
    end

    def register(value)
      formatted_val = formatted(value)
      return @registered_h[formatted_val] if @registered_h[formatted_val]
      built = Characteristic.new(next_id, formatted(formatted_val))
      @registered_h[formatted_val] = built
      @registered_ary << built
      return built
    end

    def formatted val
      val.transform_values! { |v| v.to_f }
      val
    end
  end

  class Characteristic
    attr_reader :id, :value

    def initialize(id, value)
      @id = id
      @value = value
    end

    def off_keys
      (%i[x y z] - value.keys).sort
    end

    def key
      (value.keys & %i[x y z]).sort.first
    end

    def inspect
      to_h.to_s
    end

    def to_h
      value
    end

    def to_s
      inspect
    end

    def ==(other)
      id == other.id
    end
  end
end