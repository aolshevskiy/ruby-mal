require_relative 'setup'

class ReadPrintMainLoop < Mal::MainLoop

  protected

  def eval(forms)
    forms
  end
end

if $PROGRAM_NAME == __FILE__
  ReadPrintMainLoop.new.loop
end
