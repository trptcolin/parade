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
        builder.options = options

        config = Proc.new { eval(contents) }
        builder.instance_eval(&config)

        builder.current_section
      end

      def self.build(section,options = {},&config)
        builder = new
        builder.options = options
        builder.current_section = section
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
      # This is used within the DSL to set the description of the current section.
      #
      # @param [String] new_description the description for the setion.
      #
      def description(new_description)
        current_section.description = new_description
      end

      #
      # This is used by the DSL to add additional sections. Adds the specified
      # slides or sub-sections, defined by their filepaths, as a subsection of
      # this section.
      #
      def section(*filepaths,&block)

        if block
          sub_section = Section.new :title => filepaths.flatten.compact.join(" ")
          section_content = self.class.build sub_section, options, &block
        else
          section_content = Array(filepaths).flatten.compact.map do |filepath|
            filepath = File.join(current_path,filepath)
            PresentationFilepathParser.parse(filepath,options)
          end
        end

        current_section.add_section section_content
        section_content
      end

      alias_method :slides, :section

      #
      # @param [String] content_encoding the content encoding to force on the 
      #   parsed data.
      #
      def encoding(content_encoding)
        @options[:encoding] = content_encoding
      end

      # @return [Hash] configuration options that the DSL class will use
      #   and pass to other file and directory parsers to ensure the
      #   path information is presevered correctly.
      attr_accessor :options

      # @return [String] the root path where the presentation is being served
      #   from. This path is necessary to ensure that images have the correct
      #   image path built for it.
      def root_path
        File.directory?(options[:root_path]) ? options[:root_path] : File.dirname(options[:root_path])
      end

      # @return [String] the current path is the path for the current section
      #   this usually differs from the root_path when parsing sections defined
      #   within a section (a sub-section).
      def current_path
        if options[:current_path]
          File.directory?(options[:current_path]) ? options[:current_path] : File.dirname(options[:current_path])
        else
          root_path
        end
      end

      attr_writer :current_section

      # @return [Section] the current section being built.
      def current_section
        @current_section ||= begin
          Section.new
        end
      end

    end

  end
end