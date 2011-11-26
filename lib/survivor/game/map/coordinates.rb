require 'survivor/core_ext/hash'

module Survivor
  class Game
    class Map
      class Coordinates

        class << self
          attr_reader :cache
        end

        attr_reader :x, :y

        def self.[](*args)
          (@cache ||= {}).cache(args) { new(*args) }
        end

        def initialize(x = 0, y = 0)
          @x, @y = x, y
        end

        def to_a
          [x, y]
        end

        def ==(coordinates)
          to_a == coordinates.to_a
        end

        alias :eql? :==
        alias :===  :==

        def hash
          to_a.hash
        end

        alias :to_ary   :to_a
        alias :to_array :to_a

        def to_s
          "(#{x}, #{y})"
        end

        alias :inspect :to_s

      end
    end
  end
end
