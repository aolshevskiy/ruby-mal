module Mal::Printer
  include Mal

  def self.pr_str(form)
    case form
      when nil
        'nil'
      when true, false, Integer
        form.to_s
      when String
        %{"#{form}"}
      when Types::List
        spaced_list = form.map(&method(:pr_str)).join(' ')
        "(#{spaced_list})"
      when Types::Vector
        spaced_vector = form.map(&method(:pr_str)).join(' ')
        "[#{spaced_vector}]"
      when Symbol
        ":#{form.to_s}"
      when Hash
        spaced_hash_map = form.entries.flatten.map(&method(:pr_str)).join(' ')
        "{#{spaced_hash_map}}"
      when Types::Symbol
        form.name
      when Types::Quote
        "(quote #{pr_str(form.quoted)})"
      when Types::Quasiquote
        "(quasiquote #{pr_str(form.quoted)})"
      when Types::Unquote
        "(unquote #{pr_str(form.unquoted)})"
      when Types::SpliceUnquote
        "(splice-unquote #{pr_str(form.unquoted)})"
      when Types::Deref
        "(deref #{pr_str(form.dereffed)})"
      when Types::Metadata
        "(with-meta #{pr_str(form.marked)} #{pr_str(form.metadata)})"
      else
        raise ArgumentError, "Unknown form: #{form.inspect}"
    end
  end
end
