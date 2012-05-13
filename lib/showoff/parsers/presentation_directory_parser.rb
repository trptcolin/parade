require_relative 'presentation_file_parser'

module ShowOff
  module Parsers

    module PresentationDirectoryParser

      DEFAULT_PRESENTATION_FILE = 'showoff.json'
      SLIDE_SEARCH_PATTERN = File.join('**','*.md')

      def self.parse(filepath)
        showoff_file = File.join(filepath,DEFAULT_PRESENTATION_FILE)

        if File.exists?(showoff_file)
          PresentationFileParser.parse showoff_file
        else

          sections = Dir[File.join(filepath,SLIDE_SEARCH_PATTERN)].map do |slide_file|
            { 'section' => slide_file }
          end

          { 'sections' => sections, :filepath => filepath }

        end
      end

    end

  end
end
