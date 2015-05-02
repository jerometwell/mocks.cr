module Mocks
  class Registry
    def self.for(name)
      instances[name] = instances.fetch(name) {
        new(name)
      }
    end

    def self.instances
      @@_instances ||= {} of String => self
    end

    getter methods

    def initialize(@name)
      @methods = {} of String => Method
    end

    def fetch_method(method_name)
      methods[method_name] = methods.fetch(method_name) {
        Method.new
      }
    end

    class Result(T)
      getter call_original, value

      def initialize(@call_original, @value : T)
      end
    end

    class Method
      def initialize
        @stubs = Stubs.new
      end

      def call(object_id, args)
        stubs.fetch(object_id, args, Result.new(true, nil))
      end

      def store_stub(object_id, args, value)
        stubs.add(object_id, args, Result.new(false, value))
      end

      def stubs
        @stubs
      end
    end

    class Args
      getter value

      def initialize(@value)
      end

      def ==(other)
        self.value == other.value
      end

      def hash
        value.hash
      end
    end

    class Stubs
      getter hash

      def initialize
        @hash = {} of {typeof(object_id), Args} => Result
      end

      def add(object_id, args, result)
        hash[{object_id, Args.new(args)}] = result
      end

      def fetch(object_id, args, result)
        hash.fetch({object_id, Args.new(args)}, result)
      end
    end
  end
end
