module Mal
  class Types::WithMeta < Types::List

    def initialize(marked, meta)
      self << Types::Symbol['with-meta']
      self << marked
      self << meta
    end

    def self.[](marked, meta)
      self.new(marked, meta)
    end
  end
end
