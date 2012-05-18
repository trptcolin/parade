module ShowOff
  module Helpers

    module Property

      def property(name,options = {})

        define_method name do |value = nil|

          current_value = instance_variable_get "@#{name}"

          if value
            if options[:append]
              value = (Array(current_value) + Array(value)).compact
            end

            instance_variable_set "@#{name}", value
            current_value = value
          end
          current_value
        end
      end
    end

  end
end