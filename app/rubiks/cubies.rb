module Rubiks
  class Cubies
    include Enumerable

    attr_reader :collection

    def initialize(collection)
      @collection = collection
    end

    def each
      if block_given?
        @collection.each { |cubie| yield cubie }
        return
      end

      @collection.each
    end

    def farthest_cubies_first
      collection.sort_by {|c| c.nearest_corner.z }
    end

    def nearest_cubie
      collection.max_by {|c| c.nearest_corner.z }
    end

    def reset!
      collection.each(&:reset!)
    end
  end
end