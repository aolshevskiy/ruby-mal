module Mal::Read::Driver
  include Mal::Read

  def self.read_str(source_code)
    tokens = tokenize(source_code)
    reader = Reader.new(tokens)
    reader.read_form
  end

  TOKEN_REGEX = /
      [\s,]*
      (
        ~@|
        [\[\]{}()'`~^@]|
        "(?:\\.|[^\\"])*"?|
        ;.*|
        [^\s\[\]{}('"`,;)]*
      )
    /x

  def self.tokenize(source_code)
    source_code.scan(TOKEN_REGEX).map { |m| m[0] }.filter { |t| not t.empty? }
  end
end
