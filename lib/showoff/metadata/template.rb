module ShowOff
  class Metadata

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