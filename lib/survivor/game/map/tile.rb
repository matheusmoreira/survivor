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

        alias :to_s    :char
        alias :inspect :to_s

      end
    end
  end
end
