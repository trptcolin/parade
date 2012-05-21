require_relative 'helpers/template_generator'

module ShowOff

  module Utilities
    extend self

    def generators
      { "presentation" => "A presentation folder with outline file",
         "outline" => "A generic presentation file (i.e. #{default_outline_filename})",
         "rackup" => "A default rackup file (i.e. #{rackup_filename})" }
    end

    def generate(asset_name,options)
      puts "Generating #{asset_name} with #{options}"
      send "generate_#{asset_name}", options
    end

    def generate_presentation(options)
      directory = options['dir'] || default_presentation_dirname
      Dir.mkdir(directory) unless File.exists?(directory)

      Dir.chdir(directory) do
        generate_outline(options)
      end
    end

    def generate_outline(options)
      outline_filename = options['outline'] || default_outline_filename
      create_file_with_template outline_filename, "outline_template", options
    end

    def generate_rackup(options)
      create_file_with_template rackup_filename, "rackup_template", options
    end

    def default_presentation_dirname
      "presentation"
    end

    def create_file_with_template(filename,template,options)
      return if (File.exists?(filename) and not options.key?(:force))
      File.open(filename,'w+') do |file|
        file.puts send(template,options)
      end
    end

    def render_template(options)
      template = TemplateGenerator.new options
      template.render
    end

    def default_outline_filename
      "showoff"
    end

    def outline_template(options)
      template_options = {  'erb_template_file' => File.join(File.dirname(__FILE__), "..", "templates", "#{default_outline_filename}.erb"),
                            'title' => 'My Presentation',
                            'description' => 'The importance of unicorns!' }.merge(options)

      render_template template_options
    end

    def rackup_filename
      "config.ru"
    end

    def rackup_template(options)
      template_options = {  'erb_template_file' => File.join(File.dirname(__FILE__), "..", "templates", "#{rackup_filename}.erb") }.merge(options)

      render_template template_options
    end

  end

end