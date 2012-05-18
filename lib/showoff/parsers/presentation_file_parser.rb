module ShowOff
  module Parsers

    class PresentationFileParser

      def self.parse(filepath)
        DSL.parse File.read(filepath)
      end

    end

  end
end