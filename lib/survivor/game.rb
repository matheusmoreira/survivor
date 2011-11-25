require 'survivor/game/creature/character'
require 'survivor/game/logic/movement'
require 'survivor/game/map'
require 'survivor/game/map/tile'
require 'survivor/ui'

module Survivor
  class Game

    attr_reader :character, :map

    def initialize options
      @map = Map.load(options.map_location)
      @character = Creature::Character.new.tap do |character|
        character.coordinates = map.starting_point
      end
    end

    def run
      game_loop
    end

    private

    def game_loop
      UI.run do |ui|
        loop do
          ui.display self
          handle ui.input
        end
      end
    end

    def handle input
      case input
        when :q     then exit
        when :up    then Logic::Movement.move_up    character, map
        when :down  then Logic::Movement.move_down  character, map
        when :left  then Logic::Movement.move_left  character, map
        when :right then Logic::Movement.move_right character, map
      end
    end

  end
end
