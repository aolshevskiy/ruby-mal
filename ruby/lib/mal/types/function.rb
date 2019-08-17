module Mal::Types
  Function = Struct.new(:ast, :params, :env, :fn)
end
