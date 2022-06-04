module Utils
  def slice(keys, intersection: false)
    keys.inject({}) do |m,k|
      m[k] = send(k) if (intersection || respond_to?(k))
      m
    end
  end

  def assign(hash, intersection: false)
    hash.each do |k,v|
      m = "#{k}=".to_sym
      send(m, v) if (intersection || respond_to?(m))
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