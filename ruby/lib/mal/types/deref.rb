module Mal
  class Types::Deref < Types::List

    def initialize(dereffed_form)
      self << Types::Symbol['deref']
      self << dereffed_form
    end

    def self.[](dereffed)
      self.new(dereffed)
    end
  end
end
