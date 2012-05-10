module ShowOff
  module Parsers

    class FileSlideParser
      def self.parse(filepath)

        raw_slide_contents = File.read(filepath)
        MarkdownContentParser.parse(raw_slide_contents)

      end


    end

  end
end