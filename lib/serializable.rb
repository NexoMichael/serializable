module ActiveRecord
  module AttributeMethods
    module Serialization
      module ClassMethods

        def serializable method, class_name = Object

          coder = if [:load, :dump].all? { |x| class_name.respond_to?(x) }
                    class_name
                  else
                    Coders::YAMLColumn.new(class_name)
                  end

          self.send(:define_method, "#{method}") do
            if self[method]
              @serializable_cache ||= {}
              @serializable_cache[method] ||= coder.load(self[method])
            else
              nil
            end
          end

          self.send(:define_method, "#{method}=") do |value|
            @serializable_cache ||= {}
            @serializable_cache[method] = value

            self[method] = coder.dump(value)
          end

        end

      end
    end
  end
end
