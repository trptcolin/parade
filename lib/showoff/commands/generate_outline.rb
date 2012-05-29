module ShowOff
  module Commands

    class GenerateOutline

      def name
        "outline"
      end

      def description
        "A generic presentation file (i.e. #{default_outline_filename})"
      end

      def generate(options)
        outline_filename = options['outline'] || default_outline_filename
        create_file_with_template outline_filename, "outline_template", options
      end

      def default_outline_filename
        "showoff"
      end

      def outline_template(options)
        template_options = {  'erb_template_file' => File.join(File.dirname(__FILE__), "..", "..", "templates", "#{default_outline_filename}.erb"),
                              'title' => 'My Presentation',
                              'description' => 'The importance of unicorns!' }.merge(options)

        render_template template_options
      end

      def render_template(options)
        template = TemplateGenerator.new options
        template.render
      end

      def create_file_with_template(filename,template,options)
        return if (File.exists?(filename) and not options.key?(:force))
        File.open(filename,'w+') do |file|
          file.puts send(template,options)
        end
      end

    end

  end
end