module Survivor
  module CoreExt
    class ::Hash

      def map!
        merge!(self) { |key, value| yield value }
      end

      def try_map!
        map! { |value| yield value rescue value }
      end

      def cache(key, &block)
        if self[key].nil? then self[key] = block.call end
        self[key]
      end

    end
  end
end
