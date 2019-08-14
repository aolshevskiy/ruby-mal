require 'readline'

module Mal

  module Types; end
  module Read; end

  require 'mal/env'
  require 'mal/special_forms'
  require 'mal/evaluator'
  require 'mal/main_loop'
  require 'mal/printer'
  require 'mal/readline'

  require 'mal/read/driver'
  require 'mal/read/reader'

  require 'mal/types/symbol'
  require 'mal/types/list'
  require 'mal/types/vector'
  require 'mal/types/quote'
  require 'mal/types/quasiquote'
  require 'mal/types/unquote'
  require 'mal/types/splice_unquote'
  require 'mal/types/deref'
  require 'mal/types/metadata'
end
