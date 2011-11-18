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
          stdscr.keypad true
        end
      end

      def close
        curses.close_screen
      end

      def display game
        curses.clear
        draw_map game.map
        draw_creature game.character
        curses.refresh
      end

      def input
        translate_key ::Curses.getch
      end

      private

      def curses &block
        ::Curses.tap { |curses| curses.instance_eval &block if block }
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

      def translate_key curses_key
        @@key_map[curses_key]
      end

      @@color_map = {}

      ::Curses.constants.grep(COLOR_CONSTANT_REGEX).each do |symbol|
        symbol.to_s.gsub(/^.*_/, '').downcase.to_sym.tap do |color|
          @@color_map[color] = ::Curses.const_get symbol
        end
      end

      def translate_color color
        ::Curses.color_pair @@color_map[color]
      end

      def write string, line, column, color = nil
        curses do
          setpos line, column
          attron color if color and has_colors?
          addstr string.to_s
        end
      end

      def draw_map map
        map.each_with_coordinates do |tile, (column, line)|
          write tile,
                normalized(line), column,
                translate_color(tile.color)
        end
      end

      def draw_creature creature
        write creature.char,
              normalized(creature.y), creature.x,
              translate_color(creature.color)
      end

      def normalized line
        curses.lines - line - 1
      end

    end
  end
end
