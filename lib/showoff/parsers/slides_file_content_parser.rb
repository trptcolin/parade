module ShowOff
  module Parsers

    module SlidesFileContentParser
      def self.parse(filepath)
        slides_content = File.read(filepath)
        relative_path = "."
        slides_content = Parsers::MarkdownImagePaths.parse(slides_content,:path => relative_path)
        MarkdownSlideSplitter.parse(slides_content)
      end
    end

  end
end