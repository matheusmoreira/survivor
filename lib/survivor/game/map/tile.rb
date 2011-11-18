module Survivor
  class Game
    class Map
      class Tile

        attr_reader :char, :color

        def initialize string, color = :white, passable = true
          @char = string.chars.first
          @color, @passable = color, passable
        end

        def passable?
          @passable
        end

        def == tile
          self.char == tile.char and self.passable? == tile.passable?
        end

        alias :eql? :==
        alias :===  :==

        def hash
          [@char, @passable].hash
        end

        alias :to_s :char

        def inspect
          "['#{char}' #{passable?}]"
        end

      end
    end
  end
end
