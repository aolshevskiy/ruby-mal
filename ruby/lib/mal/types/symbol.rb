class Mal::Types::Symbol

  def initialize(name)
    @name = name
  end

  attr_reader :name

  def self.[](name)
    self.new(name)
  end

  def ==(other)
    other.respond_to?(:name) && @name == other.name
  end
end
