class Colors
  attr_reader :rgba, :name

  # CHOICES = %i[black red lime blue yellow cyan fuchsia white]

  # def self.BLACK;   new([25, 25, 25, 255], :black);    end
  # def self.RED;     new([255, 0, 0, 255], :red);       end
  # def self.LIME;    new([0, 255, 0, 255], :lime);      end
  # def self.BLUE;    new([0, 0, 255, 255], :blue);      end
  # def self.YELLOW;  new([255, 255, 0, 255], :yellow);  end
  # def self.CYAN;    new([0, 255, 255, 255], :cyan);    end
  # def self.FUCHSIA; new([255, 0, 255, 255], :fuchsia); end
  # def self.WHITE;   new([0, 0, 0, 255], :white);       end


  def initialize(rgba, name)
    @rgba = rgba
    @name = name
  end

  def to_h
    r, g, b, a = rgba[0], rgba[1], rgba[2], rgba[3]
    { r: r, g: g, b: b, a: a }
  end

  def darken(proportion)
    vals = rgba.map { |v| v * proportion }
    vals[3] = rgba[3]
    self.class.new(vals, name)
  end


  BLACK   = new([25, 25, 25, 255], :black)
  RED     = new([255, 0, 0, 255], :red)
  LIME    = new([0, 255, 0, 255], :lime)
  BLUE    = new([0, 0, 255, 255], :blue)
  YELLOW  = new([255, 255, 0, 255], :yellow)
  CYAN    = new([0, 255, 255, 255], :cyan)
  FUCHSIA = new([255, 0, 255, 255], :fuchsia)
  WHITE   = new([255, 255, 255, 255], :white)


  CHOICES = [
    BLACK,
    RED,
    LIME,
    BLUE,
    YELLOW,
    CYAN,
    FUCHSIA,
    WHITE
  ]
end







