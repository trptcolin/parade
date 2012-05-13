require_relative "section"
require_relative 'renderers/command_line_renderer'
require_relative 'renderers/special_paragraph_renderer'
require_relative 'renderers/update_image_paths'

module ShowOff

  #
  # A Presentation has many Sections, which in turn have many Slides. A
  # presentation can be created with a presentation file which allows for
  # additional configuration or it can be created with a directory which will
  # attempt to create it's own sections and slides from the files it finds.
  #
  # @example Presentation creation with file
  #
  # @example Presentation creation with directory
  #
  class Presentation

    attr_accessor :filepath

    def initialize(params = {})
      params.each {|k,v| send("#{k}=",v) if respond_to? "#{k}=" }
    end

    # @return [String] if the filepath is a folder then this returns itself
    #   if it is a file then it returns the directory name.
    def rootpath
      File.directory?(filepath) ? filepath : File.dirname(filepath)
    end

    # @return [Hash] the contents of the presentation. When this is a file it
    #   will be hash parsed from the file. When a directory it will be some
    #   default data.
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

    # @return [String] the name of the presentation, defaults to 'Presentation'
    #   when no name has been specified in the file or when creating a
    #   presentation from a directory.
    def title
      contents['name'] || "Presentation"
    end

    # @return [Array<String>] an array of file paths to the section files
    def section_files
      pathpath = contents['section'] || "**/*.md"
      Dir[File.join(directory,pathpath)]
    end

    # @return [Array<Section>] an array of Section objects which have been
    #   loaded from the presentation file or directory.
    def sections
      section_files.map do |filepath|
        Section.new :filepath => filepath, :presentation => self
      end
    end

    # @return [String] the HTML content of the entire presentation.
    def to_slides_html(static = nil,pdf = nil)
      
      slide_count = 1
      
      slides_html = sections.map do |section|
        section.slides.map do |slide|
          slide.sequence = slide_count
          slide_count = slide_count + 1
          Renderers::CommandLineRenderer.render(slide.to_html)
        end
      end.flatten.join("\n")

      slides_html = Renderers::UpdateImagePaths.render(slides_html, :rootpath => rootpath)
      slides_html = Renderers::SpecialParagraphRenderer.render(slides_html)
    end

  end
end