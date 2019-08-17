class Mal::Evaluator
  include Mal

  ARGV_SYMBOL = '*ARGV*'

  def initialize
    @top_level = TopLevelEnv.new
    @top_level.set!('eval', method(:top_eval))
    @top_level.set!(ARGV_SYMBOL, Types::List[])
  end

  def set_args(args)
    @top_level.set!(ARGV_SYMBOL, Types::List[*args])
  end

  def top_eval(ast)
    eval(ast, @top_level)
  end

  def eval(ast, env)
    loop do
      if !ast.is_a?(Types::List)
        return eval_ast(ast, env)
      end
      if ast.is_a?(Types::List) && ast.empty?
        return ast
      end

      first, *rest = ast
      first_name = first.is_a?(Types::Symbol) ? first.name : nil

      case first_name
        when 'def!'
          key, value = rest
          return env.set!(key.name, eval(value, env))

        when 'let*'
          env = Env.new(env)
          bindings, result_expr = rest
          bindings.each_slice(2) do |key, value|
            env.set!(key.name, eval(value, env))
          end

          ast = result_expr

        when 'do'
          rest[0..-2].each do |e|
            eval(e, env)
          end

          ast = ast[-1]

        when 'if'
          condition, truthy, falsy = rest

          cond_result = eval(condition, env)

          if cond_result
            ast = truthy
          else
            ast = falsy
          end

        when 'fn*'
          params, body = rest
          func = Proc.new do |*exprs|
            fn_env = Env.new(env, params, exprs)
            eval(body, fn_env)
          end

          return Types::Function.new(body, params, env, func)

        when 'quote'
          return rest[0]

        when 'quasiquote'
          ast = quasiquote(rest[0])

        else
          f, *args = eval_ast(ast, env)
          case f
            when Types::Function
              ast = f.ast
              env = Env.new(f.env, f.params, args)
            else
              return f.call(*args)
          end
      end
    end
  end

  private

  def quasiquote(ast)
    if !pair?(ast)
      Types::Quote[ast]
    elsif ast[0].is_a?(Types::Symbol) && ast[0].name == 'unquote'
      ast[1]
    elsif pair?(ast[0]) && ast[0][0].is_a?(Types::Symbol) && ast[0][0].name == 'splice-unquote'
      Types::List[
        Types::Symbol['concat'],
        ast[0][1],
        quasiquote(Types::List[*ast[1..-1]])]
    else
      Types::List[
        Types::Symbol['cons'],
        quasiquote(ast[0]),
        quasiquote(Types::List[*ast[1..-1]])]
    end
  end

  def pair?(ast)
    (ast.is_a?(Types::List) || ast.is_a?(Types::Vector)) && !ast.empty?
  end

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
