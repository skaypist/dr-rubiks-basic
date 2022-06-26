module RotatingLayer
  class Controller
    attr_reader  :activity, :drag_provider

    def initialize(activity:, drag_provider:)
      @activity = activity
      @drag_provider = drag_provider
    end

    def on_tick(_args)
      @activity.toggle_rotation! if space_bar?(_args)
      @activity.add_cubes! if right_clicked?
      @activity.remove_cubes! if left_clicked?
      @activity.drag!(drag) if drag_active?
      @activity.collapse_pose! if drag_complete?
      @activity.turn!(drag) if drag_complete?
      @activity.perform_tick
    end

    def drag
      return unless drag_provider.drag_present?
      drag_provider.current # unless drag_provider.complete?
    end

    def drag_active?
      drag_provider.drag_present? && drag_provider.active?
    end

    def drag_complete?
      drag_provider.drag_present? && drag_provider.complete?
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

    def space_bar?(args)
      args.inputs.keyboard.key_up.space
    end
  end
end