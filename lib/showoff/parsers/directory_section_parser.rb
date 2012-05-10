require_relative 'file_section_parser'

module ShowOff
  module Parsers

    class DirectorySectionParser
      
      DEFAULT_SECTION_FILE = 'showoff.json'
      SLIDE_SEARCH_PATTERN = File.join('**','*.md')

      def self.parse(filepath)
        showoff_file = File.join(filepath,DEFAULT_SECTION_FILE)

        if File.exists?(showoff_file)
          FileSectionParser.parse showoff_file
        else

          sections = Dir[File.join(filepath,SLIDE_SEARCH_PATTERN)].map do |slide_file|
            { :section => slide_file }
          end

          ShowOff::Outline.new :sections => sections, :filepath => filepath

        end
      end
    end

  end
end