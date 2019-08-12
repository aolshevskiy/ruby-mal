def mal_read(input)
  input
end

def mal_eval(input)
  output = input

  output
end

def mal_print(output)
  output
end

def rep(input)
  mal_print(mal_eval(mal_read(input)))
end

if $PROGRAM_NAME == __FILE__
  loop do
    print 'user> '
    line = gets
    break if line.nil?
    puts rep(line)
  end
end
