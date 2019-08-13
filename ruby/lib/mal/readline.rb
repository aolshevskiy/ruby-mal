module Mal::Readline

  def self.mal_readline(prompt)
    while (line = Readline.readline(prompt, true))
      yield line
    end
  end

end
