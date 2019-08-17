module Mal::Types
  class Function
    def initialize(ast, params, env, fn)
      @ast = ast
      @params = params
      @env = env
      @fn = fn
      @macro = false
    end

    attr_reader :ast, :params, :env, :fn

    def macro=(macro)
      @macro = macro
    end

    def macro?
      @macro
    end

    def call(*args)
      @fn.call(*args)
    end
  end
end
