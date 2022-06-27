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

  def to_json(obj, **opts)
    defaults = {
      indent: 4,
      keep_sym: false
    }
    opts = defaults.merge opts

    case obj
    when Array
      return "[]" if obj.empty?
      str = obj.map { |v| to_json(v, **opts) }
      return "[\n#{str.join(",\n")}".indent_lines(opts[:indent]) << "\n]" if opts[:indent]
      "[#{str.join ","}]"
    when Hash
      return "{}" if obj.empty?
      str = obj.map { |k, v| "#{to_json(k, **opts)}: #{to_json(v, **opts)}" }
      return "{\n#{str.join(",\n")}".indent_lines(opts[:indent]) << "\n}" if opts[:indent]
      "{#{str.join ","}}"
    when String
      obj.quote
    when Symbol
      return obj.inspect.quote if opts[:keep_sym]
      obj.to_s.quote
    when NilClass
      'null'
    else
      obj.to_s
    end
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
end