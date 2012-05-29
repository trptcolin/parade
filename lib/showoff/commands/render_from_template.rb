require_relative '../helpers/template_generator'

module ShowOff
  module Commands

    module RenderFromTemplate
      
      def default_template_path
        File.join File.dirname(__FILE__), "..", "..", "templates"
      end
      
      def default_view_path
        File.join File.dirname(__FILE__), "..", "..", "views"
      end
      
      def render_template(options)
        template = TemplateGenerator.new options
        template.render
      end

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