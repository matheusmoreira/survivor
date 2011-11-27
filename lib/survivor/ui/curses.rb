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
        write_messages
        refresh_all
      end

      def input
        translate_key game_window.getch
      end

      def messages
        @@messages ||= []
      end

      def message(str)
        messages << str.to_s
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

      def messages_border_window
        @@messages_border_window
      end

      def messages_window
        @@messages_window
      end

      def border_windows
        [ game_border_window, messages_border_window ]
      end

      def content_windows
        [ game_window, messages_window ]
      end

      def windows
        border_windows + content_windows
      end

      def inside_of(window)
        [ window.maxy - 2, window.maxx - 2, window.begy + 1, window.begx + 1 ]
      end

      def create_windows
        height = (curses.lines * 3 / 10).to_i
        width = curses.cols
        @@game_border_window = curses::Window.new(curses.lines - height, width, 0, 0)
        @@game_window = curses::Window.new *inside_of(game_border_window)
        @@messages_border_window = curses::Window.new(height, width, game_border_window.maxy, 0)
        @@messages_window = curses::Window.new *inside_of(messages_border_window)
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

      def write_messages
        messages.last(messages_window.maxy).each do |message|
          messages_window.addstr "#{message}\n"
        end if messages and not messages.empty?
      end

      def normalized(line, window = game_window)
        window.maxy - line - 1
      end

    end
  end
end
