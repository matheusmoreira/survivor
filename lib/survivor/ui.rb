module Survivor
  module UI

    autoload :Curses, 'survivor/ui/curses'

    def self.run(ui = Curses)
      ui.init
      begin
        yield ui
      ensure
        ui.close
      end
    end

  end
end
