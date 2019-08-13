class Mal::Types::Quasiquote

  def initialize(quoted)
    @quoted = quoted
  end

  attr_reader :quoted
end
