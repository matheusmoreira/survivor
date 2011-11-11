require 'curses'

module Survivor
  module UI
    module Curses

      def init
        curses do
          noecho
          init_screen
          stdscr.keypad true
        end
      end

      def close
        curses.close_screen
      end

      def display game
        curses.clear
        draw_map game.map
        draw_character game.character
        curses.refresh
      end

      def input
        translate_key ::Curses.getch
      end

      private

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

      def curses &block
        ::Curses.tap { |curses| curses.instance_eval &block if block }
      end

      def write string, line, column
        curses do
          setpos line, column
          addstr string.to_s
        end
      end

      def draw_map map
        map.each_with_coordinates do |tile, (column, line)|
          write tile, normalized(line), column
        end
      end

      def draw_character character
        write '@', normalized(character.y), character.x
      end

      def normalized line
        curses.lines - line - 1
      end

    end
  end
end
