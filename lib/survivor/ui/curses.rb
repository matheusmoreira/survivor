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
        curses do
          clear
          refresh
        end
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

    end
  end
end
