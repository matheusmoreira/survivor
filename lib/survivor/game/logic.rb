module Survivor
  class Game
    module Logic

      def self.surroundings(creature, map, reach = {})
        map.area_around creature.coordinates, reach
      end

    end
  end
end
