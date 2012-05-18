require_relative 'presentation_filepath_parser'

module ShowOff
  module Parsers

    class DSLSection
      attr_accessor :rootpath

      def rootpath=(value)
        @rootpath = File.directory?(value) ? value : File.dirname(value)
      end

      def current_section
        @current_section ||= begin
          Section.new
        end
      end

      def title(new_title)
        current_section.title = new_title
      end

      def section(*filepaths,&block)

        section_content = Array(filepaths).flatten.compact.map do |filepath|
          filepath = File.join(rootpath,filepath)
          PresentationFilepathParser.parse(filepath)
        end

        current_section.add_section section_content
        section_content
      end
    end

    module DSL
      extend self

      def parse(contents,options = {})
        presentation = DSLSection.new
        presentation.rootpath = options[:rootpath]

        config = Proc.new { eval(contents) }
        presentation.instance_eval(&config)

        presentation.current_section
      end

    end

  end
end