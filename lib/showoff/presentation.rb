require_relative "section"
require_relative 'renderers/command_line_renderer'
require_relative 'renderers/special_paragraph_renderer'
require_relative 'renderers/update_image_paths'

require_relative 'parsers/presentation_directory_parser'
require_relative 'parsers/presentation_file_parser'
require_relative 'parsers/dsl'

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

    def self.parse(filepath)
      return nil unless File.exists? filepath

      presentation_data = if File.directory? filepath
        Parsers::PresentationDirectoryParser.parse filepath
      else
        Parsers::PresentationFileParser.parse filepath
      end

      self.new :contents => presentation_data

    end

    #
    # Create a presentation instance
    #
    # @example Create Presentation with Contents
    #
    def initialize(params = {})
      params.each {|k,v| send("#{k}=",v) if respond_to? "#{k}=" }
    end

    # The contents contains a hash of presentation data that is parsed from
    # the presentation file, directory, or sub-directories.
    attr_accessor :contents

    # @return [String] the directory that is the root of this presentation
    def filepath
      contents[:filepath]
    end

    # @return [String] the name of the presentation, defaults to 'Presentation'
    #   when no name has been specified in the file or when creating a
    #   presentation from a directory.
    def title
      contents['name'] || contents['title'] || "Presentation"
    end

    # @return [Array<Section>] an array of Section objects which have been
    #   loaded from the presentation file or directory.
    def sections
      contents['sections'].map do |section|
        if section.is_a? Hash

          if section['section'] and not section['section'].is_a? Hash

            file_sections = Array(section['section']).map do |file_section|
              { 'section' => File.expand_path(File.join(filepath,file_section)) }
            end

            section['section'] = { 'sections' => file_sections }
            puts %{

              Updated Section: #{section} #{section.class}

            }

          end

          Section.new section['section'].merge(:presentation => self)
        else
          Array(section).each do |file_section|
            # Section.new
          end
        end
      end
    end

    def renderers
      [ Renderers::UpdateImagePaths.new(:rootpath => filepath),
        Renderers::SpecialParagraphRenderer ]
    end

    # @return [String] the HTML content of the entire presentation.
    def to_html
      slides_html = sections.map {|section| section.to_html }.join("\n")
      renderers.each {|renderer| slides_html = renderer.render(slides_html) }
      slides_html
    end

  end
end