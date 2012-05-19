require_relative 'markdown_image_paths'
require_relative 'markdown_slide_splitter'

module ShowOff
  module Parsers

    module SlidesFileContentParser
      def self.parse(filepath,options = {})
        slides_content = File.read(filepath)
        
        relative_path = File.dirname(filepath).gsub(options[:root_path],'')
        
        slides_content = MarkdownImagePaths.parse(slides_content,:path => relative_path)
        MarkdownSlideSplitter.parse(slides_content)
      end
    end

  end
end