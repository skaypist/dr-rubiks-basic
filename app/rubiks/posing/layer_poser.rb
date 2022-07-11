module Posing
  class LayerPoser
    attr_reader :layer, :angle_progress, :turn_direction
    attr_reader :big_cubie

    def initialize(layer = nil, turn_direction = -1)
      @layer = layer
      @turn_direction = turn_direction
      @angle_progress = 0
      @big_cubie = big_cubie
    end

    def quaternion
      Quaternion.from_vector(around: layer.axis, by: angle_progress)
    end

    def apply_pose!
      return unless actively_posed?
      @angle_progress += (9.0 * turn_direction)
      unless turn_complete?
        current_q = quaternion
        layer.rotate!(current_q)
      else
        layer.swap_stickers(turn_direction)
        deactivate_pose!
      end
    end

    def actively_posed?
      !@layer.nil?
    end

    def turn_complete?
      angle_progress.abs.round == 90
    end

    def deactivate_pose!
      @layer = nil
    end
  end
end