module RotatingCubies
  class Controller
    attr_reader  :activity, :drag_provider

    def initialize(activity:, drag_provider:)
      @activity = activity
      @drag_provider = drag_provider
    end

    def on_tick(_args)
      @activity.add_cubie! if clicked?
      @activity.perform_tick
    end

    def clicked?
      # we should be asking a click provider
      completed = drag_provider.current if drag_provider.complete?
      completed &&
      completed.x == completed.x2 &&
        completed.y == completed.y2
    end
  end
end