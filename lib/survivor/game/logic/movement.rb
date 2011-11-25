require 'survivor/game/map/coordinates'

module Survivor
  class Game
    module Logic
      module Movement

        def self.move(creature, map, dx, dy)
          coordinates = Map::Coordinates[dx + creature.x, dy + creature.y]
          tile = map[coordinates]
          creature.coordinates = coordinates if tile and tile.passable?
        end

        def self.move_up(creature, map, n = 1)
          move creature, map, 0, n
        end

        def self.move_down(creature, map, n = 1)
          move creature, map, 0, -n
        end

        def self.move_left(creature, map, n = 1)
          move creature, map, -n, 0
        end

        def self.move_right(creature, map, n = 1)
          move creature, map, n, 0
        end

      end
    end
  end
end
