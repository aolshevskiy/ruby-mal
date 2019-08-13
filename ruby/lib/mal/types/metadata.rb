class Mal::Types::Metadata

  def initialize(marked, metadata)
    @marked = marked
    @metadata = metadata
  end

  attr_reader :marked, :metadata
end
