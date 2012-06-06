module ShowOff
  module Commands
    
    # 
    # Generate a showoff outline presentation file.
    # 
    class GenerateOutline
      include RenderFromTemplate

      def description
        "A generic presentation file (i.e. #{default_outline_filename})"
      end

      def generate(options)
        outline_filename = options['outline'] || default_outline_filename
        create_file_with_contents outline_filename, outline_template(options), options
      end

      def default_outline_filename
        "showoff"
      end

      def outline_template(options)
        template_options = {  'erb_template_file' => File.join(default_template_path, "#{default_outline_filename}.erb"),
                              'title' => 'My Presentation',
                              'description' => 'The importance of unicorns!' }.merge(options)

        render_template template_options
      end

    end

  end
end