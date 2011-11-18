require 'survivor/game/map/coordinates'

module Survivor
  class Game
    class Creature

      attr_accessor :coordinates
      attr_reader   :game, :char

      def initialize game, char
        @game, @char = game, char
        self.coordinates = Map::Coordinates.new
      end

      def x= value
        self.coordinates = Map::Coordinates[value, y]
      end

      def y= value
        self.coordinates = Map::Coordinates[x, value]
      end

      def x
        coordinates.x
      end

      def y
        coordinates.y
      end

      def move dx, dy
        tap do |c|
          coordinates = Map::Coordinates[dx + c.x, dy + c.y]
          tile = c.game.map[coordinates]
          c.coordinates = coordinates if tile and tile.passable?
        end
      end

      def move_up n = 1
        move 0, n
      end

      def move_down n = 1
        move 0, -n
      end

      def move_left n = 1
        move -n, 0
      end

      def move_right n = 1
        move n, 0
      end

      def surroundings
        game.map.area_around self
      end

    end
  end
end
