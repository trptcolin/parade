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

    # A section, when it is a folder path contains filepath information.
    # This is essential information for ensuring images and other elements
    # that require a correct path.
    #
    # @return [String] the filepath of the section. For sections
    #   that are a single file or multiple files this is the same
    #   filepath as the presentation. For folders, this is the folder
    #   path.
    attr_accessor :filepath

    # An instance of a presentation
    attr_accessor :presentation

    alias_method :rootpath, :filepath

    #
    # Sections are often created from within a presentation to allow the
    # reference to the presentation to be passed to the section.
    #
    # @example Creating a section with a filepath and presentation
    #
    #     Section.new :filepath => 'one', :presentation => self
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
    
    def create_subsection(params)
      Section.new params
    end

    #
    # @return [Array<Slide>] an array of slides contained within the section
    #   and sub-sections of this section.
    #
    def slides
      sections.map {|section| section.slides }
    end

  end
end