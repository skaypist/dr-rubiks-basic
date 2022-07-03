module Rubiks
  class Config
    extend MatrixFunctions

    def self.center
      center_corner + vec3(block_size, block_size, block_size)*0.5
    end

    def self.center_corner
      vec3(240,240,240)
    end

    def self.block_size
      120
    end

    def self.bases
      @@bases ||= [
        vec3(block_size,0,0),
        vec3(0,block_size,0),
        vec3(0,0,block_size)
      ]
    end
  end
end