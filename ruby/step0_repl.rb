require_relative 'setup'
require_relative 'step1_read_print'

class DumbMainLoop < ReadPrintMainLoop

  protected

  def read(input)
    input
  end

  def print(output)
    output
  end
end

if $PROGRAM_NAME == __FILE__
  DumbMainLoop.new.loop
end
