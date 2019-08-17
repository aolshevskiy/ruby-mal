module Mal
  class Types::Unquote < Types::List

    def initialize(unquoted)
      self << Types::Symbol['unquote']
      self << unquoted
    end

    def self.[](unquoted)
      self.new(unquoted)
    end
  end
end
