class Mal::Evaluator
  include Mal, Mal::SpecialForms

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

  def with_nested_env
    @env = Env.new(@env)
    result = yield
    @env = @env.outer
    result
  end

  private

  def apply(ast)
    if special_form?(*ast)
      apply_special_form(*ast)
    else
      op, *args = eval_ast(ast)
      op.call(*args)
    end
  end

  def eval_ast(ast)
    case ast
      when Types::Symbol
        @env.get(ast.name)
      when Types::List
        new_list = Types::List.new
        new_list.concat ast.map(&method(:eval))
      when Types::Vector
        new_vector = Types::Vector.new
        new_vector.concat ast.map(&method(:eval))
      when Hash
        ast.map {|k, v| [k, eval(v)]}.to_h
      else
        ast
    end
  end
end
