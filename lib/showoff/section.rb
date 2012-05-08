require_relative 'slides_file'

module ShowOff
  class Section

    attr_accessor :filepath
    attr_accessor :presentation

    def rootpath
      File.directory?(filepath) ? filepath : File.dirname(filepath)
    end

    def initialize(params = {})
      params.each {|k,v| send("#{k}=",v) if respond_to? "#{k}=" }
    end

    def files
      filepaths = File.directory?(filepath) ? File.join(filepath,"**","*.md") : filepath
      Dir[filepaths]
    end

    def slides
      files.map {|file| SlidesFile.new :filepath => file, :section => self }
    end

  end
end