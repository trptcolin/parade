require_relative 'renderers/update_image_paths'

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

    attr_reader :sections

    attr_accessor :rootpath

    def add_section(content)
      (@sections ||= []) << content.compact.flatten
      @sections = @sections.compact.flatten
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

    def renderers
      [ Renderers::UpdateImagePaths.new(:rootpath => rootpath) ]
    end


    # @return [String] HTML representation of the section
    def to_html
      sections.map do |section_or_slide|
        renderers.inject(section_or_slide.to_html) do |content,renderer|
          renderer.render(content)
        end
      end.join("\n")
    end

  end
end