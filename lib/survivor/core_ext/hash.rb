module Survivor
  module CoreExt
    class ::Hash

      def map!
        merge!(self) { |key, value| yield value }
      end

    end
  end
end
