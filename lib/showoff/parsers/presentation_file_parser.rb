module ShowOff
  module Parsers

    class PresentationFileParser

      def self.parse(filepath,options = {})
        DSL.parse File.read(filepath,options)
      end

    end

  end
end