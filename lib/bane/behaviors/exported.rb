module Bane
  module Behaviors

    EXPORTED = self.constants.map { |name| self.const_get(name) }.grep(Class)

  end
end