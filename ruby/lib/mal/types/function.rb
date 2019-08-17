module Mal::Types
  class Function
    def initialize(ast, params, env, fn)
      @ast = ast
      @params = params
      @env = env
      @fn = fn
      @macro = false
      @meta = nil
    end

    attr_reader :ast, :params, :env, :fn
    attr_accessor :meta
    attr_writer :macro

    def macro?
      @macro
    end

    def call(*args)
      @fn.call(*args)
    end
  end
end
