require 'survivor/game'
require 'survivor/options'
require 'survivor/ui'

module Survivor

  def self.run(options = Options.new)
    UI.run do |ui|
      Survivor::Game.new(options).run do |game|
        ui.display game
        game.handle ui.input do |input|
          ui.message input
        end
      end
    end
  end

  def self.root
    File.expand_path '../..', __FILE__
  end

  def self.maps
    File.join root, 'maps'
  end

  def self.map(filename)
    File.join maps, filename
  end

end
