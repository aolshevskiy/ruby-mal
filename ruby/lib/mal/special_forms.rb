module Mal::SpecialForms
  include Mal

  SPECIAL_FORMS = {
    'def!' => :def!,
    'let*' => :let
  }

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

  def special_form?(first, *)
    first.is_a?(Types::Symbol) && SPECIAL_FORMS.has_key?(first.name)
  end

  def apply_special_form(first, *rest)
    method_name = SPECIAL_FORMS[first.name]
    send(method_name, *rest)
  end
end
