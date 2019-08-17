class Mal::Types::Vector < Array
  def initialize(*args)
    super(*args)

    @meta = nil
  end

  attr_accessor :meta
end
