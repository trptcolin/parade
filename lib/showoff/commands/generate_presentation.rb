module ShowOff
  module Commands

    class GeneratePresentation

      def name
        "presentation"
      end

      def description
        "A presentation folder with outline file"
      end

      def generate(options)

        directory = options['dir'] || default_presentation_dirname
        Dir.mkdir(directory) unless File.exists?(directory)

        Dir.chdir(directory) do
          outline_generator = GenerateOutline.new
          outline_generator.generate(options)
        end

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

      def default_presentation_dirname
        "presentation"
      end

    end

  end
end