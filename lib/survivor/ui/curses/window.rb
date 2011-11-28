require 'curses'

module Survivor
  module UI
    module Curses
      class Window

        attr_reader   :border_window, :content_window
        attr_accessor :borders

        def initialize(height, width, top, left, *args)
          @border_window = ::Curses::Window.new(height, width, top, left)
          @content_window = ::Curses::Window.new *Window.inside_of(border_window)
          @borders = args
          windows.each do |window|
            [
              [ :keypad,   true ],
              [ :scrollok, true ]
            ].each { |args| window.send *args }
          end
        end

        def clear
          windows.each &:clear
        end

        def close
          windows.each &:close
        end

        def refresh
          windows.each &:refresh
        end

        def draw_borders
          border_window.box *borders
        end

        def input
          content_window.getch
        end

        def write(string, line = nil, column = nil, color = nil)
          with content_window do
            setpos line, column if line and column
            attron color if color
            addstr string.to_s
          end
        end

        def width
          border_window.maxx
        end

        def height
          border_window.maxy
        end

        def content_width
          content_window.maxx
        end

        def content_height
          content_window.maxy
        end

        alias :w  :width
        alias :h  :height
        alias :cw :content_width
        alias :ch :content_height

        private

        def windows
          [ border_window, content_window ]
        end

        def self.inside_of(window)
          [ window.maxy - 2, window.maxx - 2, window.begy + 1, window.begx + 1 ]
        end

      end
    end
  end
end
