module ShowOff
  module Parsers

    class PresentationFileParser

      def self.parse(filepath,options = {})
        section_options = options.merge(:current_path => File.dirname(filepath))
        Dsl.parse File.read(filepath), section_options
      end

    end

  end
end