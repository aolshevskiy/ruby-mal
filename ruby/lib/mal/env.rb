module Mal
  class Env < Hash
    def initialize(outer = nil)
      @outer = outer
      @data = {}
    end

    attr_reader :outer

    def set!(symbol_name, m_value)
      @data[symbol_name] = m_value
    end

    def find(symbol_name)
      if @data.has_key?(symbol_name)
        @data[symbol_name]
      elsif !@outer.nil?
        @outer.find(symbol_name)
      else
        nil
      end
    end

    def get(symbol_name)
      find(symbol_name) or raise NameError, "'#{symbol_name}' not found"
    end
  end

  class TopLevelEnv < Env
    def initialize
      super

      set!('+', ->(a, b){a + b})
      set!('-', ->(a, b){a - b})
      set!('*', ->(a, b){a * b})
      set!('/', ->(a, b){a / b})
    end
  end
end
