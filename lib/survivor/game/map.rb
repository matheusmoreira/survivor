require 'survivor/game/map/coordinates'
require 'survivor/game/map/custom_yaml_format'

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

      def tiles
        @map.values
      end

      def each
        @map.each_key { |coordinates| yield coordinates }
      end

      def each_tile
        @map.each_value { |tile| yield tile }
      end

      def each_with_coordinates
        @map.each { |coordinates, tile| yield tile, coordinates }
      end

      def lines
        (Hash.new { |hash, key| hash[key] = Array.new }).tap do |lines|
          group_by { |coordinate| coordinate.y }.each do |line_number, coordinates|
            coordinates.each do |coordinate|
              lines[line_number] << @map[coordinate]
            end
          end
        end
      end

      def each_line
        lines.tap do |lines|
          lines.keys.each do |line_number|
            yield lines[line_number]
          end
        end
      end

      def each_line_string
        each_line do |line|
          yield line.map(&:to_s).join
        end
      end

      def area_around coordinates, n = 1
        cx, cy = *coordinates
        n = n.abs
        #
        # (cx - n, cy + n) (cx - 1, cy + n) (cx, cy + n) (cx + 1, cy + n) (cx + n, cy + n)
        # (cx - n, cy + 1) (cx - 1, cy + 1) (cx, cy + 1) (cx + 1, cy + 1) (cx + n, cy + 1)
        # (cx - n, cy)     (cx - 1, cy)     (cx, cy)     (cx + 1, cy)     (cx + n, cy)
        # (cx - n, cy - 1) (cx - 1, cy - 1) (cx, cy - 1) (cx + 1, cy - 1) (cx + n, cy - 1)
        # (cx - n, cy - n) (cx - 1, cy - n) (cx, cy - n) (cx + 1, cy - n) (cx + n, cy - n)
        #
        Map.new.tap do |map|
          (-n).upto(n) do |x|
            (-n).upto(n) do |y|
              coordinates = Coordinates[cx + x, cy + y]
              map[coordinates] = @map[coordinates]
            end
          end
        end
      end

      def self.load filename
        raise filename.prepend("Map not found - ") unless File.file? filename
        raise filename.prepend("Map not readable - ") unless File.readable? filename
        CustomYamlFormat.from_file filename
      end

      def save filename
        CustomYamlFormat.save self, filename
      end

    end
  end
end
