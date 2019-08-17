module Mal
  class Env
    def initialize(outer = nil, binds = [], exprs = [])
      @outer = outer
      @data = {}

      binds.each_with_index do |bind, index|
        if bind.name == '&'
          set!(binds[index+1].name, Types::List[*exprs[index..-1]])
          break
        end

        set!(bind.name, exprs[index])
      end
    end

    attr_reader :outer

    def set!(symbol_name, m_value)
      @data[symbol_name] = m_value
    end

    def get(symbol_name)
      find(symbol_name)
    end

    protected

    def find(symbol_name)
      if @data.has_key?(symbol_name)
        @data[symbol_name]
      elsif !@outer.nil?
        @outer.find(symbol_name)
      else
        raise NameError, "'#{symbol_name}' not found"
      end
    end
  end

  class TopLevelEnv < Env
    def initialize
      super

      set!('*host-language*', 'ruby')

      Core::NS.symbols.each do |key, proc|
        set!(key, proc)
      end
    end
  end
end
