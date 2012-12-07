require_relative 'metadata/assignment'
require_relative 'metadata/css_classes'
require_relative 'metadata/html_id'
require_relative 'metadata/template'

module Parade

  #
  # Slides within Parade contain metadata. This metadata allows you to set
  # CSS classes and IDs. You are also able, as well to assigna unique
  # transitions between each slide.
  #
  class Metadata

    #
    # @example Raw Metadata that contains CSS Class, ID, transitions, and template data
    #
    #     metadata = Metadata.parse "transition=fade one two #id three tpl=template_name"
    #     metadata.classes # => [ 'one', 'two', 'three' ]
    #     metadata.transition # => 'fade'
    #     metadata.id # => 'id'
    #     metadata.template # => 'template_name'
    #
    # @param [String] metadata a single string that contains all the raw metadata.
    #
    def self.parse(metadata)

      metadata_hash = {}

      metadata.to_s.split(' ').each do |term|
        metadata_type = parsers.find {|parser| parser.match? term }
        metadata_type.apply(term,metadata_hash)
      end

      self.new metadata_hash
    end

    #
    # The list of the parsers that are used to parse the metadata string.
    # 
    def self.parsers
      [ Template.new,
        Assignment.new,
        HTMLId.new,
        CSSClasses.new ]
    end

    #
    # The initialize method is generally not called directly and instead is
    # used through the `Metadata.parse` method.
    # 
    # @param [Hash] params this hash contains the key-value pairs that map
    #   directly to accessor methods within the Metadata class.
    #
    # @see Metadata.parse
    # 
    def initialize(params = {})
      params.each {|k,v| send("#{k}=",v) if respond_to? "#{k}=" }
    end

    attr_writer :classes

    def classes
      @classes || []
    end

    attr_accessor :id
    attr_accessor :transition
    attr_accessor :template

  end

end