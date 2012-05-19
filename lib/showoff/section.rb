require_relative 'renderers/update_image_paths'

module ShowOff

  #
  # A ShowOff presentation is composed of a Section that may also be composed
  # of many slides and sub-sections (child sections) of slides.
  #
  class Section

    def initialize(params = {})
      @title = "Section"
      @post_renderers = []
      @sections = []
      params.each {|k,v| send("#{k}=",v) if respond_to? "#{k}=" }
    end

    # @return [String] the title of the section
    attr_accessor :title

    # @return [Array<#slides>] returns an array of a Section objects or array
    #   of Slide objects.
    attr_reader :sections

    
    # @return [Section] the parent section of this section. nil if this is a
    #   root section.
    attr_accessor :section


    #
    # Append slides or sections to this setion.
    #
    # @param [Slide,Section,Array<Section>,Array<Slide>] content this any
    #   slide or section that you want to add to this section.
    #
    def add_section(content)
      @sections = @sections + Array(content).compact.flatten.map do |content|
        content.section = self
        content
      end
    end

    # @return [Array<#render>] returns a list of Renderers that will perform
    #   their renderering on the slides after the slides have all habe been
    #   rendered.
    attr_reader :post_renderers

    #
    # @param [#render] renderer add a renderer, any object responding to
    #   #render, that will process the slides HTML content.
    #
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