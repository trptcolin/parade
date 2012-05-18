module ShowOff
  module Parsers

    class PresentationFileParser

      def self.parse(filepath,options = {})
        options.merge!(:current_path => File.dirname(filepath))
        DSL.parse File.read(filepath), options
      end

    end

  end
end