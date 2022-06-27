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
      return @registered_h[value] if @registered_h[value]
      built = Characteristic.new(next_id, value)
      @registered_h[value] = built
      @registered_ary << built
      return built
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