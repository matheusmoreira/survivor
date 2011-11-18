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

        def to_a
          [ @char, @color, @passable ]
        end

        alias :to_ary   :to_a
        alias :to_array :to_a

        def == tile
          self.to_a == tile.to_a
        end

        alias :eql? :==
        alias :===  :==

        def hash
          self.to_a.hash
        end

        alias :to_s :char

        def inspect
          "['#{char}' #{passable?}]"
        end

      end
    end
  end
end
