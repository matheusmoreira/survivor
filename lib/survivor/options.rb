require 'survivor/version'
require 'optparse'

module Survivor
  module Options

    class << self
      attr_reader :option_parser
    end

    @options = {}

    boolean_options = [ :development_mode ]

    { :enable => true, :disable => false }.each_pair do |set, state|
      boolean_options.each do |boolean_option|
        define_singleton_method("#{set}_#{boolean_option}".to_sym) do
          @options[boolean_option] = state
        end
        define_singleton_method("#{boolean_option}_enabled?".to_sym) do
          @options[boolean_option]
        end
      end
    end

    @option_parser = OptionParser.new do |parser|
      tap do |options|
        parser.instance_eval do

          on '--dev', 'Enable development mode' do
            options.enable_development_mode
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

    def self.parse
      @options.tap { @option_parser.parse }
    end

    def self.parse!
      @options.tap { @option_parser.parse! }
    end

  end
end
