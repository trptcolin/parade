require_relative '../helpers/template_generator'

module Parade
  module Commands

    #
    # A module that shares common methods and information.
    #
    module RenderFromTemplate

      # @return [String] the filepath to the templates directory within this project.
      def default_template_path
        File.join File.dirname(__FILE__), "..", "..", "templates"
      end

      #
      # @see HtmlOutput
      # @see StaticPdf
      # @return [String] the filepath to the views directory within this project
      def default_view_path
        File.join File.dirname(__FILE__), "..", "..", "views"
      end

      #
      # @param [Hash] options parameters that will help create the template
      #
      # @return [String] the string contents from the rendered template.
      def render_template(options)
        template = TemplateGenerator.new options
        template.render
      end

      #
      # @param [String] filename the file name to save the file
      # @param [String] contents the contents to write to the file
      # @param [Hash] options a hash of options which may influence whether
      #   the file should be saved or overwritten.
      #
      def create_file_with_contents(filename,contents,options)
        return if (File.exists?(filename) and not options.key?(:force))
        File.open(filename,'w+') do |file|
          file.puts contents
        end
        true
      end

    end

  end
end