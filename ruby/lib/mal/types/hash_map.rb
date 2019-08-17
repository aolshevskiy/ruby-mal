class Mal::Types::HashMap < Hash
  def initialize(*args)
    super(args)

    @meta = meta
  end

  attr_accessor :meta
end
