module ShowOff
  module Commands

    class GeneratePresentation
      include RenderFromTemplate

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

      def default_presentation_dirname
        "presentation"
      end

    end

  end
end