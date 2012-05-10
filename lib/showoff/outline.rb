require_relative 'section'

module ShowOff

  class Outline

    DEFAULT_TITLE = 'Show Off Presentation'

    attr_accessor :title, :filepath, :sections

    def initialize(params = {})
      params.each {|k,v| send("#{k}=",v) if respond_to? "#{k}=" }
    end

    def title
      @title ||= DEFAULT_TITLE
    end

    def sections=(sections_data)
      @sections = Array(sections_data).map do |section|

        unless section.is_a?(Hash)
          section = { :section => section }
        end
        
        warn "symbol keys and string keys will get you!"
        
        Section.new :outline => self, :filepath => section[:section]
      end
    end

  end
end