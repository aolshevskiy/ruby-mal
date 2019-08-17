require 'readline'

module Mal
  DIR = File.dirname(__FILE__)

  def self.relative_path(*args)
    File.join(DIR, *args)
  end

  module Core; end
  module Types; end
  module Read; end

  require 'mal/env'
  require 'mal/evaluator'
  require 'mal/main_loop'
  require 'mal/printer'
  require 'mal/readline'

  require 'mal/core/ns'

  require 'mal/read/driver'
  require 'mal/read/reader'

  require 'mal/types/symbol'
  require 'mal/types/list'
  require 'mal/types/vector'
  require 'mal/types/quote'
  require 'mal/types/quasiquote'
  require 'mal/types/unquote'
  require 'mal/types/splice_unquote'
  require 'mal/types/metadata'
  require 'mal/types/function'
  require 'mal/types/atom'
  require 'mal/types/deref'
  require 'mal/types/exception'
end
