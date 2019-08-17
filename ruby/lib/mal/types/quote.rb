module Mal
  class Types::Quote < Types::List

    def initialize(quoted)
      self << Types::Symbol['quote']
      self << quoted
    end

    def self.[](quoted)
      self.new(quoted)
    end
  end
end

