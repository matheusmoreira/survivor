module Survivor
  class Options

    def initialize options = {}
      @options = options
    end

    boolean_options = [ :development_mode ]

    { :enable => true, :disable => false }.each_pair do |set, state|
      boolean_options.each do |boolean_option|

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
