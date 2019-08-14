module Mal::Printer
  include Mal

  def self.pr_str(ast)
    case ast
      when nil
        'nil'
      when true, false, Integer
        ast.to_s
      when String
        %{"#{ast}"}
      when Types::List
        spaced_list = ast.map(&method(:pr_str)).join(' ')
        "(#{spaced_list})"
      when Types::Vector
        spaced_vector = ast.map(&method(:pr_str)).join(' ')
        "[#{spaced_vector}]"
      when Symbol
        ":#{ast.to_s}"
      when Hash
        spaced_hash_map = ast.entries.flatten.map(&method(:pr_str)).join(' ')
        "{#{spaced_hash_map}}"
      when Types::Symbol
        ast.name
      when Types::Quote
        "(quote #{pr_str(ast.quoted)})"
      when Types::Quasiquote
        "(quasiquote #{pr_str(ast.quoted)})"
      when Types::Unquote
        "(unquote #{pr_str(ast.unquoted)})"
      when Types::SpliceUnquote
        "(splice-unquote #{pr_str(ast.unquoted)})"
      when Types::Deref
        "(deref #{pr_str(ast.dereffed)})"
      when Types::Metadata
        "(with-meta #{pr_str(ast.marked)} #{pr_str(ast.metadata)})"
      else
        raise ArgumentError, "Unknown form: #{ast.inspect}"
    end
  end
end
