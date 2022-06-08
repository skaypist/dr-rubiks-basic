module RotatingCubies
  class Controller
    attr_reader  :activity, :drag_provider

    def initialize(activity:, drag_provider:)
      @activity = activity
      @drag_provider = drag_provider
    end

    def on_tick(_args)
      @activity.perform_tick
    end

    def clicked?
      # we should be asking a click provider
      completed = drag_provider.current if drag_provider.complete?
      return false unless completed
      completed.x == completed.x2 &&
        completed.y == completed.y2
    end

    def spacebar?(args)
      args.inputs.keyboard.key_up.space
    end
  end
end