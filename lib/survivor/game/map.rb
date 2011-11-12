require 'survivor/game/map/coordinates'

module Survivor
  class Game
    class Map

      include Enumerable

      attr_accessor :starting_point

      def initialize lines = 0, columns = 0, obj = nil, options = {}
        @map = Hash.new obj
        0.upto(lines.abs) do |y|
          0.upto(columns.abs) do |x|
            coordinates = Coordinates[x, y]
            @map[coordinates] = yield coordinates
          end
        end if block_given?
        @starting_point = options.fetch :starting_point, Coordinates[0, 0]
      end

      def [] coordinates
        @map[coordinates]
      end

      def []= coordinates, value
        @map[coordinates] = value
      end

      def each
        @map.each_key { |coordinates| yield coordinates }
      end

      def each_tile
        each { |coordinates| yield @map[coordinates] }
      end

      def each_with_coordinates
        each do |coordinates|
          each_tile do |tile|
            yield tile, coordinates
          end
        end
      end

      def area_around character
        cx, cy = *character.coordinates
        #
        # (cx - 1, cy + 1) (cx, cy + 1) (cx + 1, cy + 1)
        # (cx - 1, cy)       (cx, cy)   (cx + 1, cy)
        # (cx - 1, cy - 1) (cx, cy - 1) (cx + 1, cy - 1)
        #
        Map.new.tap do |map|
          -1.upto(1) do |x|
            -1.upto(1) do |y|
              coordinates = Coordinates[cx + x, cy + y]
              map[coordinates] = @map[coordinates]
            end
          end
        end
      end

    end
  end
end
