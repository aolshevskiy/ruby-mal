module Mal::Core::NS
  include Mal

  def self.symbols
    {
      '+' => method(:plus),
      '-' => method(:minus),
      '*' => method(:mul),
      '/' => method(:div),

      'prn' => method(:prn),
      'list' => method(:list),
      'list?' => method(:list?),
      'empty?' => method(:empty?),
      'count' => method(:count),

      '=' => method(:equals),
      '<' => method(:less_than),
      '<=' => method(:less_equals),
      '>' => method(:greater_than),
      '>=' => method(:greater_equals),

      'pr-str' => method(:pr_str),
      'str' => method(:str),
      'println' => method(:println)
    }
  end

  def self.plus(a, b)
    a + b
  end

  def self.minus(a, b)
    a - b
  end

  def self.mul(a, b)
    a * b
  end

  def self.div(a, b)
    a / b
  end

  def self.list(*els)
    Types::List[*els]
  end

  def self.list?(form)
    form.is_a?(Types::List)
  end

  def self.empty?(list)
    list.empty?
  end

  def self.count(list)
    return 0 if list == nil
    list.size
  end

  def self.equals(a, b)
    a == b
  end

  def self.less_than(a, b)
    a < b
  end

  def self.less_equals(a, b)
    a <= b
  end

  def self.greater_than(a, b)
    a > b
  end

  def self.greater_equals(a, b)
    a >= b
  end

  def self.pr_str(*args)
    args.map {|a| Printer.pr_str(a, true) }.join(' ')
  end

  def self.str(*args)
    args.map {|a| Printer.pr_str(a, false)}.join('')
  end

  def self.prn(*args)
    puts args.map {|a| Printer.pr_str(a, true)}.join(' ')
    nil
  end

  def self.println(*args)
    puts args.map {|a| Printer.pr_str(a, false)}.join(' ')
    nil
  end
end
