module Utils
  def slice(keys, union: false)
    keys.inject({}) do |m,k|
      m[k] = send(k) if (union || respond_to?(k))
      m
    end
  end

  def assign(hash, union: false)
    hash.each do |k,v|
      m = "#{k}=".to_sym
      send(m, v) if (union || respond_to?(m))
    end
  end

  def init_gtk
    @args = $gtk.args
  end

  module Flat
    def self.build(**kvs)
      Struct.
        new(*(kvs.keys)).
        new(*(kvs.values))
    end
  end
end

class Hash
  include MatrixFunctions

  def except!(*keys)
    keys.each { |key| delete(key) }
    self
  end

  def except(*keys)
    dup.except!(*keys)
  end

  def round
    map {|k, v| [k, v.round]}.to_h
  end

  def to_vec2
    vec2(*to_a.sort.map{|(_k,v)| v })
  end

  def to_vec3
    vec3(self[:x].to_f, self[:y].to_f, self[:z].to_f)
  end
end