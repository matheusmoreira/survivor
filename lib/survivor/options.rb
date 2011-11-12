module Survivor
  class Options

    def initialize options = {}
      @options = options
    end

    BOOLEAN_OPTIONS = [ :development_mode ].freeze

    { :enable => true, :disable => false }.each_pair do |set, state|
      BOOLEAN_OPTIONS.each do |boolean_option|

        define_method("#{set}_#{boolean_option}".to_sym) do
          @options[boolean_option] = state
        end

        define_method("#{boolean_option}_enabled?".to_sym) do
          @options[boolean_option]
        end

        define_method("#{boolean_option}_disabled?".to_sym) do
          not @options[boolean_option]
        end

      end
    end

  end
end
