require 'survivor/game'
require 'survivor/options'

module Survivor

  def self.run options = Options.new
    Survivor::Game.new(options).run
  end

  def self.root
    File.expand_path '../..', __FILE__
  end

  def self.maps
    File.join root, 'maps'
  end

  def self.map filename
    File.join maps, filename
  end

end
