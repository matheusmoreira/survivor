module Survivor
  class Game
    module Logic

      def self.surroundings(creature, map)
        map.area_around creature.coordinates
      end

    end
  end
end
