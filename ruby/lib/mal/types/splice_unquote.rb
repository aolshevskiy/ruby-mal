module Mal
  class Types::SpliceUnquote < Types::List

    def initialize(unquoted)
      self << Types::Symbol['splice-unquote']
      self << unquoted
    end

    def self.[](unquoted)
      self.new(unquoted)
    end
  end
end

