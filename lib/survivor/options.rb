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

  end
end
