require_relative '../section'
require_relative 'presentation_filepath_parser'

module ShowOff
  module Parsers

    class DSLSection
      attr_reader :root_path
      attr_reader :current_path

      def root_path=(value)
        current_section.root_path = File.directory?(value) ? value : File.dirname(value)
      end
      
      def current_path=(value)
        current_section.current_path = File.directory?(value) ? value : File.dirname(value)
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
          filepath = File.join(current_section.current_path,filepath)
          PresentationFilepathParser.parse(filepath,:root_path => current_section.root_path)
        end

        current_section.add_section section_content
        section_content
      end
    end

    module DSL
      extend self

      def parse(contents,options = {})
        presentation = DSLSection.new
        presentation.root_path = options[:root_path]
        presentation.current_path = options[:current_path] || options[:root_path]

        config = Proc.new { eval(contents) }
        presentation.instance_eval(&config)

        presentation.current_section
      end

    end

  end
end