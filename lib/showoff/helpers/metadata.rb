module ShowOff
  module Helpers

    #
    # Slides within ShowOff contain metadata. This metadata allows you to set
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
          if term =~ /^(?:tpl|template)=(.+)$/
            template_name = Regexp.last_match(1)
            metadata_hash[:template] = template_name
          elsif term =~ /.+=.+/
            key, value = term.split('=')
            metadata_hash[key] = value
          elsif term =~ /#.+/
            metadata_hash[:id] = term[1..-1]
          else
            (metadata_hash[:classes] ||= []) << term
          end
        end

        self.new metadata_hash
      end

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
end