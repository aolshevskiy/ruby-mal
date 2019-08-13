class Mal::Read::Reader
  include Mal

  def initialize(tokens)
    STDERR.puts "tokens: #{tokens.map(&:to_s).join(', ')}" if $DEBUG
    @tokens = tokens
    @position = 0
  end

  def read_form
    token = self.peek

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
    self.next
    list = Types::List.new

    loop do
      break if self.peek == ')'
      form = read_form
      list << form
    end

    self.next
    list
  end

  def read_vector
    self.next
    vector = Types::Vector.new

    loop do
      break if self.peek == ']'
      form = read_form
      vector << form
    end

    self.next
    vector
  end

  def read_hash_map
    self.next
    hash_map = {}

    loop do
      break if self.peek == '}'
      key = read_form
      value = read_form
      hash_map[key] = value
    end

    self.next
    hash_map
  end

  def read_quote
    self.next
    quoted_form = read_form
    Types::Quote.new(quoted_form)
  end

  def read_quasiquote
    self.next
    quoted_form = read_form
    Types::Quasiquote.new(quoted_form)
  end

  def read_unquote
    self.next
    unquoted_form = read_form
    Types::Unquote.new(unquoted_form)
  end

  def read_splice_unquote
    self.next
    unquoted_form = read_form
    Types::SpliceUnquote.new(unquoted_form)
  end

  def read_deref
    self.next
    dereffed_form = read_form
    Types::Deref.new(dereffed_form)
  end

  def read_metadata
    self.next
    metadata = read_form
    marked_form = read_form
    Types::Metadata.new(marked_form, metadata)
  end

  def read_atom
    token = self.next
    case
      when token == 'nil'
        nil
      when token == 'true'
        true
      when token == 'false'
        false
      when token[0] == '"'
        raise ArgumentError, 'unbalanced string' unless valid_string?(token)
        token[1..-2]
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

  def next
    token = self.peek
    @position += 1
    token
  end

  def peek
    @tokens[@position]
  end

end
