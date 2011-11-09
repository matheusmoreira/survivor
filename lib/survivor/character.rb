module Survivor
  class Character

    attr_accessor :x, :y

    def initialize
      @x = @y = 0
    end

    def move_up
      @y += 1
    end

    def move_down
      @y -= 1
    end

    def move_left
      @x -= 1
    end

    def move_right
      @x += 1
    end

    def act_on key
      case key
        when :up    then move_up
        when :down  then move_down
        when :left  then move_left
        when :right then move_right
      end
    end

  end
end
