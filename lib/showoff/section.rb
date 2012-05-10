require_relative 'slides_file'

module ShowOff
  class Section

    attr_accessor :outline
    attr_accessor :filepath
    
    #
    # Created with a path to a single configuration file or 
    # 
    # @param [Hash] params Description
    #
    def initialize(params = {})
      params.each {|k,v| send("#{k}=",v) if respond_to? "#{k}=" }
    end

    def rootpath
      File.directory?(filepath) ? filepath : File.dirname(filepath)
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