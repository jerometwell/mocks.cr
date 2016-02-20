require "./mocks/*"
require "./macro/*"

include ::Mocks::Macro::GlobalDSL

module Mocks
  extend self
  include ::Mocks::Macro

  def with_reset
    reset
    yield
    reset
  end

  def reset
    Registry.reset!
  end

  class UnexpectedMethodCall < Exception; end

  class BaseDouble
    def initialize
    end

    def initialize(stubs)
      stubs.each do |stub|
        allow(self).to stub
      end
    end

    def same?(other : Value)
      false
    end

    def self.to_s
      @@name
    end
  end

  module BaseMock
  end
end
