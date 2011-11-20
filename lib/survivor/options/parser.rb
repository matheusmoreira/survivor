require 'survivor/core_ext/kernel'
require 'survivor/version'
require 'optparse'

module Survivor
  class Options
    class Parser

      def initialize options
        @option_parser = OptionParser.new do |parser|
          with parser do
            on '--dev', 'Enable development mode' do
              options.enable_development_mode
            end

            on '--map MAP', 'Start a game on the given map.' do |map|
              options.map = map
            end

            on '-h', '--help', 'Display this help screen and exit' do
              puts self
              exit
            end

            on '--version', 'Display version and exit' do
              puts Survivor::Version
              exit
            end
          end
        end
      end

      [ :parse, :parse! ].each do |method|
        define_method(method) { @option_parser.send method }
      end

    end
  end
end
