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

  symbol 'throw', :throw
  def self.throw(value)
    raise Types::Exception[value]
  end

  symbol 'apply', :apply
  def self.apply(fn, *args)
    args.flatten!(1)
    fn.call(*args)
  end

  symbol 'map', :map
  def self.map(fn, seq)
    Types::List[*seq.map {|e| fn.call(e)}]
  end

  symbol 'nil?', :is_nil
  def self.is_nil(arg)
    arg.nil?
  end

  symbol 'true?', :true?
  def self.true?(arg)
    arg == true
  end

  symbol 'false?', :false?
  def self.false?(arg)
    arg == false
  end

  symbol 'symbol', :symbol_sym
  def self.symbol_sym(str)
    Types::Symbol[str]
  end

  symbol 'symbol?', :symbol?
  def self.symbol?(arg)
    arg.is_a?(Types::Symbol)
  end

  symbol 'keyword', :keyword
  def self.keyword(str)
    str.to_sym
  end

  symbol 'keyword?', :keyword?
  def self.keyword?(arg)
    arg.is_a?(Symbol)
  end

  symbol 'vector', :vector
  def self.vector(*els)
    Types::Vector[*els]
  end

  symbol 'vector?', :vector?
  def self.vector?(arg)
    arg.is_a?(Types::Vector)
  end

  symbol 'sequential?', :sequential?
  def self.sequential?(arg)
    arg.is_a?(Types::List) or arg.is_a?(Types::Vector)
  end

  symbol 'hash-map', :hash_map
  def self.hash_map(*args)
    args.each_slice(2).to_h
  end

  symbol 'map?', :is_map
  def self.is_map(arg)
    arg.is_a?(Hash)
  end

  symbol 'assoc', :assoc
  def self.assoc(map, *updates)
    map.merge(updates.each_slice(2).to_h)
  end

  symbol 'dissoc', :dissoc
  def self.dissoc(map, *to_remove)
    map.reject {|k, _| to_remove.include? k}
  end

  symbol 'get', :get
  def self.get(map, key)
    return nil unless map.respond_to?(:[])
    map[key]
  end

  symbol 'contains?', :contains?
  def self.contains?(map, key)
    map.has_key?(key)
  end

  symbol 'keys', :keys
  def self.keys(map)
    Types::List[*map.keys]
  end

  symbol 'vals', :vals
  def self.vals(map)
    Types::List[*map.values]
  end

end
