class Mal::Read::Reader
  include Mal

  def initialize(tokens)
    @tokens = tokens
    @position = 0
  end

  def read_form
    token = peek

    raise ArgumentError, "unbalanced token" if token.nil?

    case
      when token == '('
        read_list
      when token == '['
        read_vector
      when token == '{'
        read_hash_map
      when token == "'"
        read_quote
      when token == '`'
        read_quasiquote
      when token == '~'
        read_unquote
      when token == '~@'
        read_splice_unquote
      when token == '@'
        read_deref
      when token == '^'
        read_metadata
      else
        read_atom
    end
  end

  private

  def read_list
    next_token
    list = Types::List.new

    loop do
      break if peek == ')'
      form = read_form
      list << form
    end

    next_token
    list
  end

  def read_vector
    next_token
    vector = Types::Vector.new

    loop do
      break if peek == ']'
      form = read_form
      vector << form
    end

    next_token
    vector
  end

  def read_hash_map
    next_token
    hash_map = {}

    loop do
      break if peek == '}'
      key = read_form
      value = read_form
      hash_map[key] = value
    end

    next_token
    hash_map
  end

  def read_quote
    next_token
    quoted_form = read_form
    Types::Quote.new(quoted_form)
  end

  def read_quasiquote
    next_token
    quoted_form = read_form
    Types::Quasiquote.new(quoted_form)
  end

  def read_unquote
    next_token
    unquoted_form = read_form
    Types::Unquote.new(unquoted_form)
  end

  def read_splice_unquote
    next_token
    unquoted_form = read_form
    Types::SpliceUnquote.new(unquoted_form)
  end

  def read_deref
    next_token
    dereffed_form = read_form
    Types::List[Types::Symbol.new('deref'), dereffed_form]
  end

  def read_metadata
    next_token
    metadata = read_form
    marked_form = read_form
    Types::Metadata.new(marked_form, metadata)
  end

  def read_atom
    token = next_token
    case
      when token == 'nil'
        nil
      when token == 'true'
        true
      when token == 'false'
        false
      when token[0] == '"'
        raise ArgumentError, 'unbalanced string' unless valid_string?(token)
        read_string(token[1..-2])
      when token =~ /^-?\d+$/
        Integer(token)
      when token[0] == ':'
        token[1..-1].to_sym
      when token =~ /^[^\s()\[\]{}",'`;#|\\]+$/
        Types::Symbol.new(token)
      else
        raise ArgumentError, "unknown atom: #{token}"
    end
  end

  def read_string(unquoted)
    unquoted.gsub(/\\(["\\n])/) do |match|
      case match[1]
        when '"'
          '"'
        when '\\'
          '\\'
        when 'n'
          "\n"
      end
    end
  end

  def valid_string?(token)
    if token[-1] != '"' or token.size == 1
      return false
    end

    # Check escaped quote at the end of string
    if (m = token.match(/(\\+)"$/)) && m[1].size.odd?
      return false
    end

    true
  end

  def next_token
    token = peek
    @position += 1
    token
  end

  def peek
    @tokens[@position]
  end

end
