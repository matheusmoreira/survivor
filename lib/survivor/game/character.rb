require 'survivor/game/creature'

module Survivor
  class Game
    class Character < Creature

      def initialize game
        super game, '@'
      end

    end
  end
end
