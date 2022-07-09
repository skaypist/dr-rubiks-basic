module Posing
  class LayerPoser
    attr_reader :layer, :angle_progress

    def initialize(layer = nil)
      @layer = layer
      @angle_progress = 0
    end

    def quaternion
      Quaternion.from_vector(around: layer.axis, by: angle_progress)
    end

    def apply_pose!
      return unless actively_posed?
      @angle_progress += 3.0
      unless turn_complete?
        current_q = quaternion
        layer.rotate!(current_q)
      else
        layer.swap_stickers((angle_progress / angle_progress.abs).round)
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