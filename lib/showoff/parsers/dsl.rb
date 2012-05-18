require_relative '../section'
require_relative 'presentation_filepath_parser'

module ShowOff
  module Parsers

    class Dsl

      #
      # @param [String] contents the showoff dsl contents to parse to convert
      #   into a section with subsections and slides.
      # @param [Hash] options additional options to provide additional
      #   configuration to the parsing process.
      #
      def self.parse(contents,options = {})
        builder = new
        builder.root_path = options[:root_path]
        builder.current_path = options[:current_path] || options[:root_path]

        config = Proc.new { eval(contents) }
        builder.instance_eval(&config)

        builder.current_section
      end

      #
      # This is used within the DSL to set the title of the current section.
      #
      # @param [String] new_title the title for the setion.
      #
      def title(new_title)
        current_section.title = new_title
      end

      #
      # This is used by the DSL to add additional sections. Adds the specified
      # slides or sub-sections, defined by their filepaths, as a subsection of
      # this section.
      #
      def section(*filepaths,&block)

        section_content = Array(filepaths).flatten.compact.map do |filepath|
          filepath = File.join(current_section.current_path,filepath)
          PresentationFilepathParser.parse(filepath,:root_path => current_section.root_path)
        end

        current_section.add_section section_content
        section_content
      end


      # @return [String] the root path where the presentation is being served
      #   from. This path is necessary to ensure that images have the correct
      #   image path built for it.
      attr_reader :root_path

      #
      # @param [String] value is a directory or a file that is the root path
      #   of this presentation of where it is being served.
      #
      def root_path=(value)
        current_section.root_path = File.directory?(value) ? value : File.dirname(value)
      end

      # @return [String] the current path is the path for the current section
      #   this usually differs from the root_path when parsing sections defined
      #   within a section (a sub-section).
      attr_reader :current_path

      #
      # @param [String] value is a directory or a file that is the root path
      #   for this particular section of the presentation being served.
      #
      def current_path=(value)
        current_section.current_path = File.directory?(value) ? value : File.dirname(value)
      end

      # @return [Section] the current section being built.
      def current_section
        @current_section ||= begin
          Section.new
        end
      end

    end

  end
end