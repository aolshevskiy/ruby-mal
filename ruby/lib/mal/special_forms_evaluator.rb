class Mal::SpecialFormsEvaluator < Mal::Evaluator
  include Mal

  def initialize
    super

    @form_dispatch = {
      'def!' => method(:def!),
      'let*' => method(:let),
      'do' => method(:do),
      'if' => method(:if_f),
      'fn*' => method(:fn)
    }
  end

  private

  def def!(key, value)
    env.set!(key.name, eval(value))
  end

  def let(bindings, result_expr)
    with_nested_env do
      bindings.each_slice(2) do |key, value|
        env.set!(key.name, eval(value))
      end
      eval(result_expr)
    end
  end

  def do(*ast)
    result = nil
    ast.each do |e|
      result = eval(e)
    end
    result
  end

  def if_f(condition, truthy, falsy = nil)
    cond_result = eval(condition)

    if !cond_result.nil? && cond_result != false
      eval(truthy)
    elsif not falsy.nil?
      eval(falsy)
    else
      nil
    end
  end

  def fn(binds, body)
    closed_env = env

    Proc.new do |*exprs|
      fn_env = Env.new(closed_env, binds, exprs)
      with_env(fn_env) do
        eval(body)
      end
    end
  end

  def apply(ast)
    if special_form?(ast.first)
      apply_special_form(*ast)
    else
      super(ast)
    end
  end

  def special_form?(form)
    form.is_a?(Types::Symbol) && @form_dispatch.has_key?(form.name)
  end

  def apply_special_form(form, *args)
    method = @form_dispatch[form.name]
    method.call(*args)
  end
end
