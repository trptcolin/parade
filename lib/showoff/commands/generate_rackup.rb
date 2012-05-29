module ShowOff
  module Commands

    class GenerateRackup

      def name
        "rackup"
      end

      def description
        "A default rackup file (i.e. #{rackup_filename})"
      end

      def generate(options)
        create_file_with_template rackup_filename, "rackup_template", options
      end

      def rackup_filename
        "config.ru"
      end

      def rackup_template(options)
        template_options = {  'erb_template_file' => File.join(File.dirname(__FILE__), "..", "..", "templates", "#{rackup_filename}.erb") }.merge(options)

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