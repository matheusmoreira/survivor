module Survivor
  module Game
    class Map
      class Coordinates

        class << self
          alias :[] :new
        end

        attr_reader :x, :y

        def initialize x = 0, y = 0
          @x, @y = x, y
        end

        def == coordinates
          self.x == coordinates.x and self.y == coordinates.y
        end

        alias :eql? :==
        alias :===  :==

        def to_a
          [x, y]
        end

        alias :to_ary :to_a

        def to_s
          "(#{x}, #{y})"
        end

        alias :inspect :to_s

      end
    end
  end
end