require_relative 'renderers/update_image_paths'

module ShowOff

  #
  # Within a ShowOff Presention file, sections can be defined. These sections
  # can either be a markdown file, an arrary of markdown files, or a folder
  # path which may contain markdown files.
  #
  class Section

    def initialize
      @post_renderers = []
    end

    attr_accessor :title
    attr_reader :sections

    attr_accessor :root_path
    attr_accessor :current_path

    def add_section(content)
      (@sections ||= []) << Array(content).compact.flatten
      @sections = @sections.compact.flatten
    end

    attr_accessor :post_renderers
    
    def add_post_renderer(renderer)
      @post_renderers << renderer
    end
    
    # @return [String] HTML representation of the section
    def to_html
      sections.map do |section_or_slide|
        post_renderers.inject(section_or_slide.to_html) do |content,renderer|
          renderer.render(content)
        end
      end.join("\n")
    end

  end
end