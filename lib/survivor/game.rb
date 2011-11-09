require 'survivor/ui'

module Survivor
  module Game

    def self.run
      UI.run do |ui|
        loop do
          ui.display self
          key = ui.input
        end
      end
    end

  end
end
