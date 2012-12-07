module Parade
  module Commands

    #
    # Generates the a Rackup `config.ru` file to allow for presentations to
    # be deployed to locations like Heroku.
    #
    class GenerateRackup
      include RenderFromTemplate

      def description
        "A default rackup file (i.e. #{rackup_filename})"
      end

      def generate(options)
        create_file_with_contents rackup_filename, rackup_template(options), options
      end

      def rackup_filename
        "config.ru"
      end

      def rackup_template(options)
        template_options = {  'erb_template_file' => File.join(default_template_path, "#{rackup_filename}.erb") }.merge(options)

        render_template template_options
      end

    end

  end
end