class Mal::MainLoop
  include Mal

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

  def eval(input)
    output = input

    output
  end

  def print(form)
    Printer.pr_str(form)
  end

  def rep(input)
    print(eval(read(input)))
  end

end
