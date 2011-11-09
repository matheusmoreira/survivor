require 'survivor/character'
require 'survivor/ui'

module Survivor
  module Game

    def self.character
      @character
    end

    def self.run
      @character = Character.new
      game_loop
    end

    private

    def self.game_loop
      UI.run do |ui|
        loop do
          ui.display self
          key = ui.input
          character.act_on key unless self.handle key
        end
      end
    end

    def self.handle key
      case key
        when :q then exit
      end
    end

  end
end
