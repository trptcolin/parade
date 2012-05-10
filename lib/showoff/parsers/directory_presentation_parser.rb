require_relative 'file_presentation_parser'

module ShowOff
  module Parsers

    class DirectoryPresentationParser
      
      DEFAULT_PRESENTATION_FILE = 'showoff.json'
      SLIDE_SEARCH_PATTERN = File.join('**','*.md')

      def self.parse(filepath)
        showoff_file = File.join(filepath,DEFAULT_PRESENTATION_FILE)

        if File.exists?(showoff_file)
          FilePresentationParser.parse showoff_file
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