require_relative 'setup'

# self.merge!({
#   '+' => ->(a, b) {a + b},
#   '-' => ->(a, b) {a - b},
#   '*' => ->(a, b) {a * b},
#   '/' => ->(a, b) {a / b},
# })
#
# Mal::MainLoop.new()

Mal::MainLoop.new.loop
