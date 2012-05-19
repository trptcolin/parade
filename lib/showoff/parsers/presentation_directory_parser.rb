require_relative 'presentation_file_parser'
require_relative 'slides_file_content_parser'

module ShowOff
  module Parsers

    module PresentationDirectoryParser

      SLIDE_SEARCH_PATTERN = File.join('**','*.md')

      def self.parse(filepath,options = {})
        showoff_file = File.join(filepath,options[:showoff_file])

        if File.exists?(showoff_file)
          PresentationFileParser.parse showoff_file, options
        else
          
          slides = Dir[File.join(filepath,SLIDE_SEARCH_PATTERN)].map do |slide_filepath|
            SlidesFileContentParser.parse slide_filepath, options
          end
          
          section = Section.new 
          section.add_section slides
          section
          
        end
      end

    end

  end
end
