class Mal::Types::Deref

  def initialize(dereffed)
    @dereffed = dereffed
  end

  attr_reader :dereffed
end
