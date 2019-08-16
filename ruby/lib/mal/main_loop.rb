class Mal::MainLoop
  include Mal

  def initialize(evaluator = Evaluator.new)
    @evaluator = evaluator
  end

  PROMPT = 'user> '
  def loop
    init

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
    @evaluator.top_eval(ast)
  end

  def print(ast)
    Printer.pr_str(ast, true)
  end

  def rep(input)
    print(eval(read(input)))
  end

  private
  def init
    mal_dir = File.join(File.dirname(__FILE__), '..')
    init_script_path = File.join(mal_dir, 'init.mal')
    init_script = File.read(init_script_path)

    rep(init_script.strip)
  end
end
