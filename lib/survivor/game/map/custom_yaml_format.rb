require 'survivor/game/map'
require 'survivor/game/map/coordinates'
require 'survivor/game/map/tile'
require 'survivor/version'
require 'yaml'

module Survivor
  class Game
    class Map
      class CustomYamlFormat

        def self.save(map, filename)
          File.open(filename, 'w') do |file|
            file.write custom_structure_for(map).to_yaml
          end
        end

        def self.from_file(filename)
          from_yaml File.open(filename) { |file| YAML::load file }
        end

        def self.from_yaml(string)
          survivor = string['survivor']
          version = survivor['version']
          unless Survivor::Version == version
            puts "Map meant for Survivor v#{version} - current version is v#{Survivor::Version}"
          end
          build_map survivor['map']
        end

        private

        def self.build_map(map_hash)
          tiles = map_hash['tiles']
          Map.new.tap do |map|
            map_hash['data'].split("\n").tap do |lines|
              lines.each_with_index do |line, y|
                line.chars.each_with_index do |char, x|
                  args = []
                  if tile_data = tiles[char]
                    args << tile_data.fetch('color', :white).to_sym
                    args << tile_data.fetch('passable', true)
                  end
                  tile = Tile.new char, *args
                  map[Coordinates[x, lines.count - y - 1]] = tile
                end
              end
            end
            start = map_hash['starting point']
            x, y = start['x'].to_i, start['y'].to_i
            map.starting_point = Coordinates[x, y]
          end
        end

        def self.custom_structure_for(map)
          {}.tap do |data|
            (data['survivor'] = {}).tap do |survivor|
              survivor['version'] = Survivor::Version.to_s
              (survivor['map'] = {}).tap do |map_hash|
                (map_hash['starting point'] = {}).tap do |starting_point|
                  starting_point['x'] = map.starting_point.x
                  starting_point['y'] = map.starting_point.y
                end
                (map_hash['tiles'] = {}).tap do |tiles|
                  map.tiles.uniq.each do |tile|
                    (tiles[tile.char] = {}).tap do |tile_data|
                      tile_data['color'] = tile.color.to_s
                      tile_data['passable'] = tile.passable?
                    end
                  end
                end
                (map_hash['data'] = '').tap do |data|
                  map.each_line_string do |line|
                    data << "#{line}\n"
                  end
                end
              end
            end
          end
        end

      end
    end
  end
end
