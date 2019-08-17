class Mal::Printer
  include Mal

  def initialize(print_readably)
    @print_readably = print_readably
  end
  
  def self.pr_str(ast, print_readably = false)
    Printer.new(print_readably).do_pr_str(ast)
  end

  def do_pr_str(ast)
    case ast
      when nil
        'nil'
      when true, false, Integer
        ast.to_s
      when String
        print_string(ast)
      when Types::List
        spaced_list = ast.map {|e| do_pr_str(e)}.join(' ')
        "(#{spaced_list})"
      when Types::Vector
        spaced_vector = ast.map {|e| do_pr_str(e)}.join(' ')
        "[#{spaced_vector}]"
      when Symbol
        ":#{ast.to_s}"
      when Hash
        spaced_hash_map = ast.entries.flatten.map {|e| do_pr_str(e)}.join(' ')
        "{#{spaced_hash_map}}"
      when Types::Symbol
        ast.name
      when Types::NativeFunction, Types::Function
        "#<function>"
      when Types::Atom
        "(atom #{ast.value})"
      when Types::Exception
        do_pr_str(ast.value)
      else
        raise ArgumentError, "Unknown form: #{ast.inspect}"
    end
  end

  private
  def print_string(str)
    if @print_readably
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
