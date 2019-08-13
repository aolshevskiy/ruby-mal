require_relative 'setup'
require 'mal'

class DumbMainLoop < Mal::MainLoop
  protected
  def read(input)
    input
  end

  def print(output)
    output
  end
end

DumbMainLoop.new.loop
