require_relative 'presentation_filepath_parser'
require_relative '../helpers/property'

module ShowOff
  module Parsers

    class DSLSection
      extend ::ShowOff::Helpers::Property

      property :title

      attr_reader :sections

      def section(*filepaths,&block)
        section_content = Array(filepaths).flatten.compact.map do |filepath|
          PresentationFilepathParser.parse(filepath)
        end

        sub_section = DSLSection.new :content => section_content

        (@sections ||= []) << sub_section

        sub_section
      end


    end

    module DSL
      extend self

      def parse(contents)

        presentation = DSLSection.new

        config = Proc.new { eval(contents) }

        presentation.instance_eval(&config)

        presentation
      end

    end

  end
end