module Survivor
  module CoreExt
    class ::Hash

      def map!
        merge!(self) { |key, value| yield value }
      end

      def try_map!
        map! { |value| yield value rescue value }
      end

    end
  end
end
