require 'survivor/game/map/coordinates'

module Survivor
  class Character

    attr_accessor :coordinates

    def initialize
      self.coordinates = Survivor::Game::Map::Coordinates.new
    end

    def x= value
      self.coordinates = Survivor::Game::Map::Coordinates.new value, y
    end

    def y= value
      self.coordinates = Survivor::Game::Map::Coordinates.new x, value
    end

    def x
      coordinates.x
    end

    def y
      coordinates.y
    end

    def move_up
      self.y += 1
    end

    def move_down
      self.y -= 1
    end

    def move_left
      self.x -= 1
    end

    def move_right
      self.x += 1
    end

  end
end