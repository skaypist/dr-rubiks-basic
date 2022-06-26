module Rubiks
  class Factory
    include MatrixFunctions

    attr_reader :center_corner, :block_size
    def initialize(center_corner, block_size)
      @center_corner, @block_size = center_corner, block_size
    end

    def build
      cubies = build_cubies
      layers = layers(cubies)
      initial_transform = QuaternionPose.build_initial(bases, center_corner)
      Cube.new(cubies, layers, initial_transform)
    end

    def build_cubies
      geometric_cubes = build_geometric_cubes
      geometric_cubes.map do |gc|
        cubie_factory.build(gc)
      end
    end

    def cubie_factory
      @_cubie_factory ||= CubieFactory.new(bases, center_corner)
    end

    def layers(cubies)
      LayersManagerFactory.new(cubies, bases, center_corner).build
    end

    def build_geometric_cubes
      (1..3).to_a.map do |dim_count|
        bases
          .product([-1, 1])
          .map { |d, c| d*c }
          .combination(dim_count)
          .map {|combo| combo.reduce(center_corner, &:+) }
          .map {|block_corner| Cubes::Factory.build(block_corner, bases) }
      end.flatten(1).uniq { |c| c.initial.sort_by(&:mag2) }
    end

    def big_cubie
      @big_cubie ||= calculate_big_cubie
    end

    def calculate_big_cubie
      cube_corner = center_corner - bases.reduce(&:+)
      cube_bases = bases.map { |b| b*3.0 }
      big_cube = Cubes::Factory.build(cube_corner , cube_bases)
      big_cubie = CubieFactory.new(bases, center_corner).build(big_cube, true)
=begin
      cube_faces = big_cubie.faces.map do |face|
        CubeFace.new(face.points, face.color, face.characteristic)
      end
=end
      # CubeFaces.new(big_cubie, cube_faces)
      puts "big_cubie.faces:"
      big_cubie.faces.each { |f| puts f.inspect }
      puts "---"
      big_cubie
      # CubeFaces.new(big_cubie, big_cubie.faces)
    end

    def bases
      @bases ||= [
        vec3(block_size,0,0),
        vec3(0,block_size,0),
        vec3(0,0,block_size)
      ]
    end
  end

  # class CubeFaces
  #   include Enumerable
  #   attr_reader :cubie
  #
  #   def initialize(big_cubie, cube_faces)
  #     @cube_faces = cube_faces
  #     @cubie = big_cubie
  #   end
  #
  #   def each
  #     @cube_faces.each { |cubie| yield cubie } if block_given?
  #     @cube_faces.each
  #   end
  #
  #   def visible
  #     chars = cubie.visible_faces.map(&:characteristic)
  #     # @cube_faces.sort_by do |cf|
  #     #   cf.geometric_face.max_by(&:z).z
  #     # end.last(3)
  #     @cube_faces.select { |cube_face| chars.include?(cube_face.characteristic) }
  #   end
  # end
  #
  # class CubeFace
  #   include CheckFaceContains
  #   attr_reader :geometric_face, :color, :characteristic
  #
  #   def inspect
  #     { color: color.name,
  #       characteristic: characteristic.inspect,
  #       # start: geometric_face.first,
  #       # edge1: line_between(0,1).round,
  #       # edge2: line_between(3,0).round
  #     }.to_s
  #   end
  #
  #   def initialize(geometric_face, color, characteristic)
  #     @characteristic = characteristic
  #     @geometric_face = geometric_face
  #     @color = color
  #   end
  #
  #   # def contains?(point)
  #   #   between_first_pair?(point) &&
  #   #     between_second_pair?(point)
  #   # end
  #   #
  #   # def between_first_pair?(point)
  #   #   ray_test(point, line_between(0,1)) != ray_test(point, line_between(3, 2))
  #   # end
  #   #
  #   # def between_second_pair?(point)
  #   #   ray_test(point, line_between(3,0)) != ray_test(point, line_between(2, 1))
  #   # end
  #   #
  #   # def ray_test(point, line)
  #   #   $gtk.args.geometry.ray_test(
  #   #     point.except(:z),
  #   #     line
  #   #   )
  #   # end
  #   #
  #   # def line_between(i, j)
  #   #   geometric_face[i].to_h.except(:z).
  #   #     merge(x2: geometric_face[j].x, y2: geometric_face[j].y)
  #   # end
  # end
end