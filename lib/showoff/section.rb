require_relative 'slides_file'

module ShowOff

  #
  # Within a ShowOff Presention file, sections can be defined. These sections
  # can either be a markdown file, an arrary of markdown files, or a folder
  # path which may contain markdown files.
  #
  # @example Section with a markdown file
  #
  # @example Section with multiple markdown files
  #
  # @example Section with a folder path
  #
  class Section

    # An instance of a presentation
    attr_accessor :presentation

    #
    # Sections are often created from within a presentation to allow the
    # reference to the presentation to be passed to the section.
    #
    # @param [Hash] params a Hash of parameters which help define the Section
    #
    def initialize(params = {})
      presentation = params[:presentation]
      params.each {|k,v| send("#{k}=",v) if respond_to? "#{k}=" }
    end

    def sections
      @sections || []
    end

    #
    # A section may contain sections which are files, `SlidesFiles`, and
    # sub-sections which is a Hash that can also contain more sections information
    #
    # @param [Hash] subsections which contains sections and sub-sections
    #
    def sections=(subsections)
      @sections = subsections.map do |section|
        if section['section'].is_a?(Hash)
          create_subsection section['section'].merge(:presentation => presentation)
        else
          SlidesFile.new(:filepath => section['section'], :section => self)
        end
      end
    end

    #
    # @return [Array<Slide>] an array of slides contained within the section
    #   and sub-sections of this section.
    #
    def slides
      sections.map {|section| section.slides }.flatten
    end

    def renderers
      [ Renderers::CommandLineRenderer ]
    end

    # @return [String] HTML representation of the section
    def to_html
      slides.map do |slide|
        slide_html = slide.to_html
        renderers.each {|render| slide_html = render.render(slide_html) }
        slide_html

      end.join("\n")
    end

    private

    def create_subsection(params)
      Section.new params
    end

  end
end