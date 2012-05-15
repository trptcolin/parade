require_relative 'presentation_directory_parser'

module ShowOff
  module Parsers

    class PresentationFileParser

      def self.parse(filepath)

        file_rootpath = File.dirname(filepath)

        presentation_data = JSON.parse(File.read(filepath))
        presentation_data.merge!(:filepath => file_rootpath)
        presentation_data

        presentation_data['sections'].each do |section|

          if section.is_a?(Hash) and section['section']
            section_path = File.join(file_rootpath, section['section'])

            if File.exists?(section_path) and File.directory?(section_path)
              section['section'] = PresentationDirectoryParser.parse(section_path)
            end

          end
        end

        presentation_data

      end

    end

  end
end