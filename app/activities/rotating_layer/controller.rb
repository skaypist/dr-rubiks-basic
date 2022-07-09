module RotatingLayer
  class Controller
    attr_reader  :activity, :drag_provider

    def initialize(activity:, drag_provider:)
      @activity = activity
      @drag_provider = drag_provider
    end

    def on_tick(_args)
      refresh_drag_apparently!
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

    def refresh_drag_apparently!
      drag_provider.current if drag_provider.complete?
    end
  end
end