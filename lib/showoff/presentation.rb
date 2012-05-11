require_relative "section"
require_relative 'renderers/command_line_renderer'
require_relative 'renderers/special_paragraph_renderer'
require_relative 'renderers/update_image_paths'

module ShowOff
  class Presentation

    attr_accessor :filepath

    def initialize(params = {})
      params.each {|k,v| send("#{k}=",v) if respond_to? "#{k}=" }
    end

    def rootpath
      File.directory?(filepath) ? filepath : File.dirname(filepath)
    end

    def contents
      if File.exists? filepath
        file_data = File.read(filepath)
        JSON.parse(file_data)
      else
        { 'name' => 'Presentation', 'sections' => ['.'] }
      end

      # TODO: there are defaults that need to be merged here as well
    end

    def directory
      File.expand_path(File.dirname(filepath) || ".")
    end

    #
    #
    #
    def title
      contents['name'] || "Presentation"
    end

    def section_files
      pathpath = contents['section'] || "**/*.md"
      Dir[File.join(directory,pathpath)]
    end

    def sections
      section_files.map do |filepath|
        Section.new :filepath => filepath, :presentation => self
      end
    end

    #
    #
    #
    def to_slides_html(static = nil,pdf = nil)
      slides_html = sections.map do |section|
        section.slides.map do |slide|
          Renderers::CommandLineRenderer.render(slide.to_html)
        end
      end.flatten.join("\n")

      slides_html = Renderers::UpdateImagePaths.render(slides_html)
      slides_html = Renderers::SpecialParagraphRenderer.render(slides_html)
    end

  end
end