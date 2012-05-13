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

    # @return [String] if the filepath is a folder then this returns itself
    #   if it is a file then it returns the directory name.
    def rootpath
      File.directory?(filepath) ? filepath : File.dirname(filepath)
    end

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
      params.each {|k,v| send("#{k}=",v) if respond_to? "#{k}=" }
    end

    #
    # @return [Array<String>] an array of file names within the section. When
    #   the section is a file or list of files it is simply the file itself. If
    #   it is a directory it returns all the markdown files contained in any of
    #   the sub-directories.
    #
    def files
      filepaths = File.directory?(filepath) ? File.join(filepath,"**","*.md") : filepath
      Dir[filepaths]
    end

    #
    # @return [Array<Slide>] an array of slides contained within the section.
    #
    def slides
      files.map {|file| SlidesFile.new(:filepath => file, :section => self).to_slides }.flatten
    end

  end
end