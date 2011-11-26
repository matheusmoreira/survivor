require 'survivor/game/map/coordinates'

module Survivor
  class Game
    class Creature

      attr_accessor :coordinates
      attr_reader   :char, :color

      def initialize(char, color = :white)
        @char, @color = char, color
        self.coordinates = Map::Coordinates.new
      end

      def x=(value)
        self.coordinates = Map::Coordinates[value, y]
      end

      def y=(value)
        self.coordinates = Map::Coordinates[x, value]
      end

      def x
        coordinates.x
      end

      def y
        coordinates.y
      end

    end
  end
end
