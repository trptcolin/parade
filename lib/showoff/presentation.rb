require_relative "outline"
require_relative "section"
require_relative "parsers/file_presentation_parser"
require_relative "parsers/directory_presentation_parser"

module ShowOff

  #
  # The core model. A presentation.
  #
  class Presentation

    def self.load(filepath)
      filepath ||= "."

      raise "No file or directory at the path specified #{filepath}" unless File.exists? filepath

      config_data = if File.directory? filepath
        Parsers::DirectoryPresentationParser.parse(filepath)
      else
        Parsers::FilePresentationParser.parse(filepath)
      end

      Presentation.new :outline => config_data
    end

    #
    # Create a instance of a presentation. A presentation is created with a
    # hash that contains the presentation information
    #
    # @example Creating a presentation with a path (defaults to showoff.json)
    #
    #     Presentation.new :filepath => 'path/to/folder'
    #
    # @example Creating a presentation with a presentation file
    #
    #     Presentation.new :filepath => 'path/to/presentation/customized.json'
    #
    # @param [Hash] params a hash of parameters that define the presentation
    #
    def initialize(params = {})
      # params.each {|k,v| send("#{k}=",v) if respond_to? "#{k}=" }
    end

    # def filepath(newpath)
    #   #
    #   # if File.exists?(newpath)
    #   #   if File.directory?(newpath)
    #   #
    #   #   elsif File.file
    #   #
    #   #   end
    #   # end
    #   #
    # end

    #
    # When the filepath has not been specified, it defaults to the current
    # working directory.
    #
    # @return [String] a presentation file or presentation folder
    #
    def filepath
      @filepath ||= "."
    end

    #
    # The root directory of the presentation.
    # @return [String] the file path of the presentation.
    #
    def rootpath
      File.directory?(filepath) ? filepath : File.dirname(filepath)
    end

    def contents
      if File.exists? filepath
        file_data = File.read(filepath)
        JSON.parse(file_data)
      else
        { 'title' => 'Presentation', 'sections' => [ rootpath ] }
      end

      # TODO: there are defaults that need to be merged here as well
    end

    def directory
      File.expand_path(File.dirname(filepath))
    end

    #
    #
    #
    def title
      contents['title'] || "Presentation"
    end

    def section_files
      sectionpaths = contents['sections'] || [ { 'section' => "**/*.md" } ]
      sectionpaths.map do |section,path_or_name|
        Dir[File.join(directory,path_or_name)]
      end.flatten.compact
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
      sections.map {|section| section.slides.map {|slide| slide.to_html}}.flatten.join("\n")
    end

  end
end