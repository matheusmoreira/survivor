require 'survivor/ui/curses'

module Survivor
  module UI

    extend UI::Curses

    def self.run
      self.init
      begin
        yield self
      ensure
        self.close
      end
    end

  end
end
