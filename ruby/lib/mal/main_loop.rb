class Mal::MainLoop
  include Mal

  def initialize(evaluator = Evaluator.new)
    @evaluator = evaluator
  end

  PROMPT = 'user> '
  def loop
    load_file('init.mal')

    unless ARGV.empty?
      batch(*ARGV)
      return
    end

    load_file('interactive.mal')

    Readline.mal_readline(PROMPT) do |line|
      puts rep(line)
    rescue StandardError => e
      puts e.inspect
    end
  end

  protected

  def batch(mal_file, *args)
    @evaluator.set_args(args)
    rep(%{(load-file "#{mal_file}")})
  end

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

  def load_file(*file_parts)
    script_path = Mal.relative_path(*file_parts)
    contents = File.read(script_path)

    rep("(do #{contents} nil)")
  end
end
