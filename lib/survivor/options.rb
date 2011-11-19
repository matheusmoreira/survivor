require 'survivor'
require 'pathname'

module Survivor
  class Options

    def initialize options = {}
      @options = options
    end

    BOOLEAN_OPTIONS = [ :development_mode ].freeze.tap do |boolean_options|
      boolean_options.each do |boolean_option|

        define_method("#{boolean_option}_enabled?".to_sym) do
          @options[boolean_option]
        end

        define_method("#{boolean_option}_disabled?".to_sym) do
          not @options[boolean_option]
        end

        { :enable => true, :disable => false }.each_pair do |set, state|
          define_method("#{set}_#{boolean_option}".to_sym) do
            @options[boolean_option] = state
          end
        end

      end
    end

    VALUE_OPTIONS = [ :map ].freeze.tap do |value_options|
      value_options.each do |value_option|

        define_method(value_option) do |default = nil|
          @options.fetch(value_option, default)
        end

        alias :"#{value_option}_with_default" :"#{value_option}"

        define_method("#{value_option}=".to_sym) do |value|
          @options[value_option] = value
        end

      end
    end

    def map_location(default = 'test.map.yaml')
      map = map_with_default(default)
      if Pathname.new(map).relative?
        File.join(Survivor.maps, map)
      else
        map
      end
    end

  end
end
