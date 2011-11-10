require 'survivor/game/map/coordinates'

module Survivor
  module Game
    class Map

      include Enumerable

      def initialize lines, columns, obj = nil
        @map = Hash.new obj
        1.upto(lines) do |x|
          1.upto(columns) do |y|
            coordinates = Coordinates[x, y]
            @map[coordinates] = yield coordinates
          end
        end if block_given?
      end

      def [] coordinates
        @map[coordinates]
      end

      def each
        @map.each_key { |coordinates| yield @map[coordinates] }
      end

      def each_with_coordinates
        @map.each_key do |coordinates|
          yield @map[coordinates], coordinates
        end
      end

      alias :each_with_index :each_with_coordinates

    end
  end
end