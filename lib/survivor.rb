require 'survivor/game'

module Survivor

  def self.root
    File.expand_path '../..', __FILE__
  end

  def self.maps
    File.join root, 'maps'
  end

  def self.map filename
    File.join maps, filename
  end

  def self.run(argv)
    Survivor::Game.new.run
  end

end
