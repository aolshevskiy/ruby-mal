class Mal::Evaluator
  include Mal

  def initialize(env = TopLevelEnv.new)
    @env = env
  end

  def eval(ast)
    case
      when ast.is_a?(Types::List) && ast.empty?
        ast
      when ast.is_a?(Types::List)
        apply(ast)
      else
        eval_ast(ast)
    end
  end

  protected

  def env
    @env
  end

  def with_env(other_env)
    old_env = @env
    @env = other_env
    result = yield
    @env = old_env
    result
  end

  def with_nested_env
    new_env = Env.new(@env)

    with_env(new_env) do
      yield
    end
  end

  def apply(ast)
    op, *args = eval_ast(ast)
    op.call(*args)
  end

  def eval_ast(ast)
    case ast
      when Types::Symbol
        @env.get(ast.name)
      when Types::List
        Types::List[*ast.map(&method(:eval))]
      when Types::Vector
        Types::Vector[*ast.map(&method(:eval))]
      when Hash
        ast.map {|k, v| [k, eval(v)]}.to_h
      else
        ast
    end
  end
end
