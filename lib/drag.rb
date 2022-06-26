module Dragging
  class DragProvider
    include Utils
    attr_gtk

    def self.instance
      @@inst ||= new
    end

    def initialize
      init_gtk
      @current = Flat.build(
        x: nil,
        y: nil,
        x2: nil,
        y2: nil,
        digest: nil,
        active: false,
        complete: false,
        modifier: nil,
        btn: nil,
      )
      @last_updated = state.tick_count
    end

    def active?; current.active; end
    def complete?; current.complete; end
    def present?; active? || complete?; end
    def drag_present?
      @current.x2 && @current.y2 &&
        @current.x && @current.y &&
        (active? || complete?)
    end

    def current
      update! unless up_to_date?
      @current
    end

    private

    def update!
      reset && return if keyboard.escape || @current.complete

      if !@current.active && (mouse.button_left || mouse.button_right)
        @current.x = mouse.x
        @current.y = mouse.y
        @current.digest = mouse.x * mouse.y
        @current.active = true
        @current.complete = false
        @current.modifier = modifier
        @current.btn = mouse.button_left ? :left : :right
      elsif @current.active
        @current.x2 = mouse.x
        @current.y2 = mouse.y
        if ((!mouse.button_left && left_btn?) || (!mouse.button_right && right_btn?))
          @current.active = false
          @current.complete = true
        end
      end

      @last_updated = state.tick_count
    end

    def left_btn?
      @current.btn == :left
    end

    def right_btn?
      @current.btn == :right
    end

    def reset
      @current.x = nil
      @current.y = nil
      @current.digest = nil
      @current.x2 = nil
      @current.y2 = nil
      @current.active = false
      @current.complete = false
      @current.modifier = nil
      @current.btn = nil
    end

    def modifier
      if keyboard.key_held.shift
        :shift
      elsif keyboard.key_held.meta
        :cmd
      else
        nil
      end
    end

    def keyboard
      inputs.keyboard
    end

    def mouse
      inputs.mouse
    end

    def up_to_date?
      @last_updated == state.tick_count
    end
  end
end