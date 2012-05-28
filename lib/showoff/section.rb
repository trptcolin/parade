require_relative 'renderers/update_image_paths'

module ShowOff

  #
  # A ShowOff presentation is composed of a Section that may also be composed
  # of many slides and sub-sections (child sections) of slides.
  #
  class Section

    def initialize(params = {})
      @description = ""
      @post_renderers = []
      @sections = []
      params.each {|k,v| send("#{k}=",v) if respond_to? "#{k}=" }
    end

    # @param [String] title the new title of the section
    attr_writer :title

    # @return [String] the title of the section
    def title
      @title ? @title : (section ? section.title : "Section")
    end

    # @return [String] the description of the section
    attr_accessor :description

    # @return [Array<#slides>] returns an array of a Section objects or array
    #   of Slide objects.
    attr_reader :sections

    # @return [Section] the parent section of this section. nil if this is a
    #   root section.
    attr_accessor :section

    #
    # Append sections to this section.
    #
    # @param [Section,Array<Section>] content this any section that you want to
    #   add to this section.
    #
    def add_section(sub_sections)
      sub_sections = Array(sub_sections).compact.flatten.map do |sub_section|
        sub_section.section = self
        sub_section
      end
      @sections = @sections + sub_sections
      sub_sections
    end

    #
    # Append slides to this setion.
    #
    # @param [Slide,Array<Slide>] content this any section that you want to
    #   add to this section.
    #
    def add_slides(slides)
      sub_slides = Array(slides).compact.flatten.map do |slide|
        slide.section = self
        slide
      end

      @sections = @sections + sub_slides
      sub_slides
    end

    # @return [Array<Slide>] the slides contained within this section and any
    #   sub-section.
    def slides
      sections.map do |section_or_slide|
        section_or_slide.slides
      end.flatten
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