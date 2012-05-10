require_relative "renderers/html_with_pygments"
require_relative 'slide'
require_relative 'parsers/markdown_slide_splitter'
require_relative 'parsers/markdown_image_paths'

module ShowOff
  class SlidesFile

    attr_accessor :filepath
    attr_accessor :section

    def initialize(params = {})
      @cached_image_size = {}
      params.each {|k,v| send("#{k}=",v) if respond_to? "#{k}=" }
    end

    def rootpath
      File.directory?(filepath) ? filepath : File.dirname(filepath)
    end

    def markdown_content
      File.read(filepath)
    end

    def to_slides
      content = Parsers::MarkdownImagePaths.parse(markdown_content,:path => rootpath.gsub(section.presentation.rootpath,''))
      slides = Parsers::MarkdownSlideSplitter.parse(content)
      slides
    end

  end
end