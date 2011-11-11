require 'survivor/game'

module Survivor

  def self.run(argv)
    Survivor::Game.new.run
  end

end
