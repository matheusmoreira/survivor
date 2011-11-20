module Survivor
  module CoreExt
    module ::Kernel

      def with(object, &block)
        object.instance_eval(&block)
      end

    end
  end
end
