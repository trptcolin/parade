module Parade
  class Metadata

    #
    # The Template metadata allows the specification of a template to use for
    # the slide. This is extremely similar to the {Assignment} parser, except
    # it allows for the previously supported abbreviation *tpl* for representing
    # template.
    # 
    class Template

      def match?(term)
        term =~ /^(?:tpl|template)=(.+)$/
      end

      def apply(term,hash)
        hash[:template] = parse(term)
        hash
      end

      private

      def parse(term)
        term =~ /^(?:tpl|template)=(.+)$/
        template_name = Regexp.last_match(1)
      end

    end

  end
end