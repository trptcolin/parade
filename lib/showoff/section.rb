
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
    attr_accessor :title

    # An instance of a presentation
    attr_accessor :presentation

    def add_section(content)
      sections << content
    end

    def sections
      @sections ||= []
    end

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

    #
    # @return [Array<Slide>] an array of slides contained within the section
    #   and sub-sections of this section.
    #
    def slides
      sections.flatten.map {|section| section.slides }.flatten
    end

    # def renderers
    #   [ Renderers::CommandLineRenderer ]
    # end

    # @return [String] HTML representation of the section
    def to_html
      sections.map do |section_or_slide|
        Array(section_or_slide.flatten).map {|s_or_s| s_or_s.to_html }
        # renderers.each {|render| slide_html = render.render(slide_html) }
        # slide_html
      end.flatten.join("\n")
    end

  end
end