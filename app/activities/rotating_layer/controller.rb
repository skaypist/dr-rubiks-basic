module RotatingLayer
  class Controller
    attr_reader  :activity, :drag_provider

    def initialize(activity:, drag_provider:)
      @activity = activity
      @drag_provider = drag_provider
    end

    def on_tick(_args)
      @activity.toggle_rotation! if spacebar?(_args)
      @activity.add_cubes! if right_clicked?
      @activity.remove_cubes! if left_clicked?
      @activity.perform_tick
    end

    def click
      # we should be asking a click provider
      drag_provider.current if drag_provider.complete?
    end

    def right_clicked?
      click && click.btn == :right
    end

    def left_clicked?
      click && click.btn == :left
    end

    def spacebar?(args)
      args.inputs.keyboard.key_up.space
    end
  end
end