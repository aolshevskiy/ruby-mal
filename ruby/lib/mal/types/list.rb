class Mal::Types::List < Array
  def initialize(*args)
    super(*args)

    @meta = nil
  end

  attr_accessor :meta
end
