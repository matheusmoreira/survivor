module Survivor
  module Version

    MAJOR = 0
    MINOR = 1
    PATCH = 0
    BUILD = 'alpha2'

    STRING = [ MAJOR, MINOR, PATCH, BUILD ].compact.join '.'

    def self.==(string)
      STRING == string
    end

    def self.to_s
      STRING
    end

  end
end
