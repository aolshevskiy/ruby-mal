module Mal::Printer
  include Mal

  def self.pr_str(ast, print_readably = false)
    case ast
      when nil
        'nil'
      when true, false, Integer
        ast.to_s
      when String
        print_string(ast, print_readably)
      when Types::List
        spaced_list = ast.map {|e| pr_str(e, print_readably)}.join(' ')
        "(#{spaced_list})"
      when Types::Vector
        spaced_vector = ast.map {|e| pr_str(e, print_readably)}.join(' ')
        "[#{spaced_vector}]"
      when Symbol
        ":#{ast.to_s}"
      when Hash
        spaced_hash_map = ast.entries.flatten.map {|e| pr_str(e, print_readably)}.join(' ')
        "{#{spaced_hash_map}}"
      when Types::Symbol
        ast.name
      when Types::Quote
        "(quote #{pr_str(ast.quoted, print_readably)})"
      when Types::Quasiquote
        "(quasiquote #{pr_str(ast.quoted, print_readably)})"
      when Types::Unquote
        "(unquote #{pr_str(ast.unquoted, print_readably)})"
      when Types::SpliceUnquote
        "(splice-unquote #{pr_str(ast.unquoted, print_readably)})"
      when Types::Deref
        "(deref #{pr_str(ast.dereffed, print_readably)})"
      when Types::Metadata
        "(with-meta #{pr_str(ast.marked, print_readably)} #{pr_str(ast.metadata, print_readably)})"
      when Proc
        "#<function>"
      else
        raise ArgumentError, "Unknown form: #{ast.inspect}"
    end
  end

  private
  def self.print_string(str, print_readably)
    if print_readably
      contents = str.gsub(/["\\\n]/) do |match|
        case match
          when '"'
            '\\"'
          when '\\'
            '\\\\'
          when "\n"
            '\\n'
        end
      end
      %{"#{contents}"}
    else
      str
    end
  end
end
