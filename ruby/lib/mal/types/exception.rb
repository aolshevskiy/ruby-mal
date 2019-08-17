class Mal::Types::Exception < StandardError
  def initialize(message)
    super
    @value = message
  end

  attr_reader :value

  def self.[](message)
    self.new(message)
  end
end
