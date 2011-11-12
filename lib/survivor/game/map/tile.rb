module Survivor
  class Game
    class Map
      class Tile

        attr_reader :char

        def initialize string, passable = true
          @char = string.chars.first
          @passable = passable
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
