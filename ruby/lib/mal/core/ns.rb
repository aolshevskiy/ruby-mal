module Mal::Core::NS
  include Mal

  @symbol_mapping = {}

  def self.symbol(sym, func)
    @symbol_mapping[sym] = func
  end

  def self.symbols
    @symbols ||= Hash[@symbol_mapping.map {|key, value| [key, method(value)]}]
  end

  symbol '+', :plus
  def self.plus(a, b)
    a + b
  end

  symbol '-', :minus
  def self.minus(a, b)
    a - b
  end

  symbol '*', :mul
  def self.mul(a, b)
    a * b
  end

  symbol '/', :div
  def self.div(a, b)
    a / b
  end

  symbol 'list', :list
  def self.list(*els)
    Types::List[*els]
  end

  symbol 'list?', :list?
  def self.list?(form)
    form.is_a?(Types::List)
  end

  symbol 'empty?', :empty?
  def self.empty?(list)
    list.empty?
  end

  symbol 'count', :count
  def self.count(list)
    return 0 if list == nil
    list.size
  end

  symbol '=', :equals
  def self.equals(a, b)
    a == b
  end

  symbol '<', :less_than
  def self.less_than(a, b)
    a < b
  end

  symbol '<=', :less_equals
  def self.less_equals(a, b)
    a <= b
  end

  symbol '>', :greater_than
  def self.greater_than(a, b)
    a > b
  end

  symbol '>=', :greater_equals
  def self.greater_equals(a, b)
    a >= b
  end

  symbol 'pr-str', :pr_str
  def self.pr_str(*args)
    args.map {|a| Printer.pr_str(a, true) }.join(' ')
  end

  symbol 'str', :str
  def self.str(*args)
    args.map {|a| Printer.pr_str(a, false)}.join('')
  end

  symbol 'prn', :prn
  def self.prn(*args)
    puts args.map {|a| Printer.pr_str(a, true)}.join(' ')
    nil
  end

  symbol 'println', :println
  def self.println(*args)
    puts args.map {|a| Printer.pr_str(a, false)}.join(' ')
    nil
  end

  symbol 'read-string', :read_string
  def self.read_string(str)
    Read::Driver.read_str(str)
  end

  symbol 'slurp', :slurp
  def self.slurp(filename)
    File.read(filename)
  end

  symbol 'atom', :atom
  def self.atom(value)
    Types::Atom.new(value)
  end

  symbol 'atom?', :atom?
  def self.atom?(maybe_atom)
    maybe_atom.is_a?(Types::Atom)
  end

  symbol 'deref', :deref
  def self.deref(atom)
    atom.value
  end

  symbol 'reset!', :reset!
  def self.reset!(atom, value)
    atom.value = value
  end

  symbol 'swap!', :swap!
  def self.swap!(atom, fn, *fns)
    fn = fn.fn if fn.is_a?(Types::Function)
    atom.value = fn.call(atom.value, *fns)
  end

  symbol 'cons', :cons
  def self.cons(e, list)
    Types::List[e, *list]
  end

  symbol 'concat', :concat
  def self.concat(*lists)
    Types::List[*lists.flatten(1)]
  end

  symbol 'nth', :nth
  def self.nth(seq, index)
    seq.fetch(index)
  end

  symbol 'first', :first
  def self.first(seq)
    return nil if !seq.respond_to?(:[]) || seq.empty?

    seq[0]
  end

  symbol 'rest', :rest
  def self.rest(seq)
    return Types::List[] unless seq.respond_to?(:[])

    Types::List[*seq[1..-1]]
  end
end
