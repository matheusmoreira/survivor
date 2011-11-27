require 'survivor/core_ext/kernel'
require 'curses'

module Survivor
  module UI
    module Curses

      COLOR_CONSTANT_REGEX = /^COLOR_\w+$/i

      def init
        curses do
          init_screen
          if has_colors?
            start_color
            const_get(:COLOR_BLACK).tap do |background_color|
              constants.grep(COLOR_CONSTANT_REGEX).map do |symbol|
                const_get symbol
              end.each do |color|
                init_pair color, color, background_color
              end
            end
          end
          noecho
          cbreak
        end
        create_windows
      end

      def close
        close_windows
        curses.close_screen
      end

      def display(game)
        clear_all
        draw_window_borders
        draw_map game.map
        draw_creature game.character
        refresh_all
      end

      def input
        translate_key game_window.getch
      end

      private

      def curses(&block)
        ::Curses.tap { |curses| with(curses, &block) if block }
      end

      def game_border_window
        @@game_border_window
      end

      def game_window
        @@game_window
      end

      def border_windows
        [ game_border_window ]
      end

      def content_windows
        [ game_window ]
      end

      def windows
        border_windows + content_windows
      end

      def create_windows
        @@game_border_window = curses::Window.new(curses.lines, curses.cols, 0, 0)
        @@game_window = curses::Window.new(game_border_window.maxy - 2,
                                           game_border_window.maxx - 2,
                                           game_border_window.begy + 1,
                                           game_border_window.begx + 1)
        windows.each do |window|
          [ [ :keypad, true ], [ :scrollok, true ] ].each do |args|
            window.send *args
          end
        end
      end

      def close_windows
        windows.each &:close
      end

      def clear_all
        windows.each &:clear
      end

      def refresh_all
        windows.each &:refresh
      end

      def draw_window_borders
        border_windows.each { |window| window.box '|', '-' }
      end

      @@key_map = {
        ::Curses::Key::UP    => :up,
        ::Curses::Key::DOWN  => :down,
        ::Curses::Key::LEFT  => :left,
        ::Curses::Key::RIGHT => :right
      }

      ('a'..'z').each do |char|
        @@key_map[char] = char.to_sym if char.ascii_only?
      end

      def translate_key(curses_key)
        @@key_map[curses_key]
      end

      @@color_map = {}

      ::Curses.constants.grep(COLOR_CONSTANT_REGEX).each do |symbol|
        symbol.to_s.gsub(/^.*_/, '').downcase.to_sym.tap do |color|
          @@color_map[color] = ::Curses.const_get symbol
        end
      end

      def translate_color(color)
        ::Curses.color_pair @@color_map[color]
      end

      def write_on(window, string, line, column, color = nil)
        with window do
          setpos line, column
          attron color if color
          addstr string.to_s
        end
      end

      def draw_map(map)
        map.each_with_coordinates do |tile, (column, line)|
          write_on game_window, tile,
                                normalized(line), column,
                                translate_color(tile.color) if tile
        end
      end

      def draw_creature(creature)
        write_on game_window, creature.char,
                              normalized(creature.y), creature.x,
                              translate_color(creature.color) if creature
      end

      def normalized(line, window = game_window)
        window.maxy - line - 1
      end

    end
  end
end
