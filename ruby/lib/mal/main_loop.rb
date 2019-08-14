class Mal::MainLoop
  include Mal

  def initialize(evaluator = Evaluator.new)
    @evaluator = evaluator
  end

  PROMPT = 'user> '
  def loop
    Readline.mal_readline(PROMPT) do |line|
      puts rep(line)
    rescue StandardError => e
      puts e.inspect
    end
  end

  protected

  def read(raw_input)
    Read::Driver.read_str(raw_input)
  end

  def eval(ast)
    @evaluator.eval(ast)
  end

  def print(ast)
    Printer.pr_str(ast)
  end

  def rep(input)
    print(eval(read(input)))
  end

end
