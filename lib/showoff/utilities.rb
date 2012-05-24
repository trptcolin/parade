require_relative 'helpers/template_generator'
require_relative 'renderers/inline_images'

module ShowOff

  module Utilities
    extend self

    def statics
      { "html" => "Output into a single HTML file",
        "pdf" => "Output into a PDF format" }
    end

    def static(output_type,options)
      puts "Generating #{output_type} with #{options}"
      send "static_#{output_type}", options
    end

    def static_html(options)
      options.merge!('template' => 'onepage')
      html_content = html_from_template(options)

      output_file = options[:output] || default_html_output

      return if (File.exists?(output_file) and not options.key?(:force))

      File.open(output_file,'w') {|file| file.puts html_content }

      puts "Saved HTML to #{output_file}"
    end

    def default_html_output
      "presentation.html"
    end

    def static_pdf(options)
      options.merge!('template' => 'pdf')

      html_content = html_from_template(options)
      kit = PDFKit.new(html_content,:page_size => 'Letter', :orientation => 'Landscape')

      output_file = options[:output] || default_pdf_output

      return if (File.exists?(output_file) and not options.key?(:force))

      kit.to_file(output_file)

      puts "Saved PDF to #{output_file}"
    end

    def default_pdf_output
      "presentation.pdf"
    end

    def html_from_template(options)
      filepath = options['filepath']

      return unless File.exists? filepath

      if File.directory? filepath
        root_path = filepath
        root_node = Parsers::PresentationDirectoryParser.parse filepath, :root_path => ".",
          :showoff_file => (Array(options['showoff_file']) + [ "showoff", "showoff.json" ]).compact.uniq
      else
        root_path = File.dirname filepath
        root_node = Parsers::PresentationFileParser.parse filepath, :root_path => root_path
      end

      root_node.add_post_renderer Renderers::InlineImages

      template_options = {  'erb_template_file' => File.join(File.dirname(__FILE__), "..", "views", "#{options['template']}.erb"),
                            'custom_asset_path' => root_path,
                            'slides' => root_node.to_html }

      render_template template_options
    end


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