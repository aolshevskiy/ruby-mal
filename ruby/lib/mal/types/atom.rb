class Mal::Types::Atom
  def initialize(value)
    @value = value
    @meta = nil
  end

  attr_accessor :value, :meta
end
