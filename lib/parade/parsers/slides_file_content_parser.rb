require_relative 'markdown_image_paths'
require_relative 'markdown_slide_splitter'

module Parade
  module Parsers

    module SlidesFileContentParser
      def self.parse(filepath,options = {})
        slides_content = File.read(filepath)
        relative_path = File.dirname(filepath).gsub(options[:root_path].gsub(/\/$/,''),'')
        slides_content = MarkdownImagePaths.parse(slides_content,:path => relative_path)

        create_section_with slides_content
      end

      private

      def self.create_section_with(slides_content)
        section = Section.new
        section.add_slides(MarkdownSlideSplitter.parse(slides_content))
        section
      end

    end

  end
end