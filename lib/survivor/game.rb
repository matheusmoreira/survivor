require 'survivor/character'
require 'survivor/game/map'
require 'survivor/ui'

module Survivor
  module Game

    class << self
      attr_reader :character, :map
    end

    def self.run
      @character = Character.new
      @map = Map.new(24, 80) { [ ' ', '#', '%', "\n" ].sample }
      game_loop
    end

    private

    def self.game_loop
      UI.run do |ui|
        loop do
          ui.display self
          handle ui.input
        end
      end
    end

    def self.handle input
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
