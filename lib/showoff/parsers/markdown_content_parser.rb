module ShowOff
  module Parsers

    class MarkdownContentParser
      def self.parse(content)
        slides = MarkdownSlideSplitter.parse(content)
      end
  end
end