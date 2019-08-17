module Mal
  class Types::Quasiquote < Types::List

    def initialize(quoted)
      self << Types::Symbol['quasiquote']
      self << quoted
    end

    def self.[](quoted)
      self.new(quoted)
    end
  end
end
