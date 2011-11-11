require 'survivor/game/character'
require 'survivor/game/map'
require 'survivor/game/map/tile'
require 'survivor/ui'

module Survivor
  class Game

    attr_reader :character, :map

    def initialize
      @character = Character.new self
      @map = Map.new(24, 80) do
        [ Map::Tile.new(' '), Map::Tile.new('#', false) ].sample
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
        when :up    then character.move_up
        when :down  then character.move_down
        when :left  then character.move_left
        when :right then character.move_right
      end
    end

  end
end
