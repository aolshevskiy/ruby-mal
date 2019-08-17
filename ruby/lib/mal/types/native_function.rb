module Mal
  class Types::NativeFunction
    def initialize(delegate)
      @delegate = delegate
      @meta = nil
    end

    attr_accessor :meta

    def self.[](delegate)
      self.new(delegate)
    end

    def call(*args)
      @delegate.call(*args)
    end
  end
end
