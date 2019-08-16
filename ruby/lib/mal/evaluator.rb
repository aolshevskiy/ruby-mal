class Mal::Evaluator
  include Mal

  def initialize
    @top_level = TopLevelEnv.new
  end

  def top_eval(ast)
    eval(ast, @top_level)
  end

  def eval(ast, env)
    if !ast.is_a?(Types::List)
      return eval_ast(ast, env)
    end
    if ast.is_a?(Types::List) && ast.empty?
      return ast
    end

    first, *rest = ast

    if first.is_a?(Types::Symbol)
      case first.name
        when 'def!'
          key, value = rest
          return env.set!(key.name, eval(value, env))

        when 'let*'
          let_env = Env.new(env)
          bindings, result_expr = rest
          bindings.each_slice(2) do |key, value|
            let_env.set!(key.name, eval(value, let_env))
          end

          return eval(result_expr, let_env)

        when 'do'
          result = nil
          rest.each do |e|
            result = eval(e, env)
          end
          return result

        when 'if'
          condition, truthy, falsy = rest

          cond_result = eval(condition, env)

          result = if !cond_result.nil? && cond_result != false
            eval(truthy, env)
          elsif not falsy.nil?
            eval(falsy, env)
          else
            nil
          end

          return result

        when 'fn*'
          binds, body = rest
          result = Proc.new do |*exprs|
            fn_env = Env.new(env, binds, exprs)
            eval(body, fn_env)
          end

          return result
      end
    end

    op, *args = eval_ast(ast, env)
    op.call(*args)
  end

  protected

  def eval_ast(ast, env)
    case ast
      when Types::Symbol
        env.get(ast.name)
      when Types::List
        Types::List[*ast.map { |f| eval(f, env) }]
      when Types::Vector
        Types::Vector[*ast.map { |f| eval(f, env) }]
      when Hash
        ast.map { |k, v| [k, eval(v, env)] }.to_h
      else
        ast
    end
  end
end
